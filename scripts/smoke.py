#!/usr/bin/env python3
"""OpenResty Lua request workflow; static-asset identity, no stateful volume claim."""
import hashlib, json, os, secrets, urllib.error, urllib.parse, urllib.request
from pathlib import Path
b=os.environ['BASE_URL'].rstrip('/');phase=os.environ['SMOKE_PHASE']
assert phase in ('boot','upgrade','redeploy')
p=Path(__file__).parent/('state-'+hashlib.sha256(b.encode()).hexdigest()[:16]+'.json')
if p.exists():state=json.loads(p.read_text())
else:
 assert phase=='boot','missing initial asset fingerprint; refusing to reseed'
 state={'marker':secrets.token_hex(12)}
def request(method,path,payload=None,status=200):
 headers={'Content-Type':'application/json'}
 req=urllib.request.Request(b+path,method=method,headers=headers,data=None if payload is None else json.dumps(payload).encode())
 try:r=urllib.request.urlopen(req,timeout=90)
 except urllib.error.HTTPError as e:r=e
 with r:raw=r.read();code=r.code;response_headers=r.headers
 assert code==status,f'{method} {path} unexpected status {code}'
 return raw,response_headers
assert json.loads(request('GET','/health')[0])['status']=='ok'
hello=json.loads(request('GET','/api/hello')[0])
assert hello['runtime']=='OpenResty' and hello['application'] and hello['greeting'] and hello['requestId']
raw,headers=request('POST','/api/echo?'+urllib.parse.urlencode({'probe':state['marker']}),{'marker':state['marker']})
echo=json.loads(raw)
assert echo['method']=='POST' and echo['path']=='/api/echo' and echo['query']['probe']==state['marker']
assert json.loads(echo['body'])['marker']==state['marker']
assert echo['requestId'] and echo['requestId']!=hello['requestId']
assert headers['X-Content-Type-Options']=='nosniff'
asset=request('GET','/openresty.png')[0];assert asset.startswith(b'\x89PNG\r\n\x1a\n')
digest=hashlib.sha256(asset).hexdigest()
if 'asset_sha256' in state:assert state['asset_sha256']==digest,'bundled asset identity changed'
else:
 assert phase=='boot','missing initial asset hash'
 state['asset_sha256']=digest;p.write_text(json.dumps(state))
request('GET','/not-a-real-route',status=404)
print(json.dumps({'phase':phase,'ok':True,'asset_sha256':digest,'scope':'stateless Lua and JSON echo; immutable bundled asset; no writable volume'}))
