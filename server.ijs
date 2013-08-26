load'socket'
coinsert 'jsocket'
 
Sleep=:'kernel32 Sleep n i' & cd
ResumeThread=: 'kernel32 ResumeThread i x'&cd
SuspendThread=: 'kernel32 SuspendThread i x'&cd

sddupe=: 3 : 0
st64=: -.&'.'^:(-.IF64)
GetProcessId=:   'kernel32 GetProcessId   > x i' & cd
WSAPROTOCOL_INFO=:  st64 'Flag1....Flag2....Flag3....Flag4....ProvFlags....ProvID....Catalog....Version....Family....MaxSockAddr....MinSockAddr....Type....Protocol....Offset....Order....MessageSize....Reserved....Protocol'
WSADuplicateSocketJ=: 'ws2_32 WSADuplicateSocketW i i i *c'

s=:> 0} y
hpid=:> 1} y

pi=: szero WSAPROTOCOL_INFO
pid=:GetProcessId hpid
ret=:WSADuplicateSocketJ cd s;pid;pi
smoutput 'process thread is'
smoutput th

arrbin  =: 3!:1
(arrbin pi) fwrite 'shared.txt'

ResumeThread th
)

forkj=: 3 : 0
szero=: # # (0{a.)"_
ptr=: int`i64@.IF64
sptr=: sint`si64@.IF64
int=: {.@:(_2&ic)
sint=: 2&ic
st64=: -.&'.'^:(-.IF64)
i64=: {.@:(_3&ic)
si64=: 3&ic
sndx=: i.@#@[ + {.@I.@E.

NB. struct=. 'valu' 'memb' sset structdef struct
sset=: 2 : '(m sndx n)}'

NB. value=. 'memb' sget structdef struct
sget=: 2 : '(m sndx n)&{'

'Outh Errh Inph Proh Thrh'=: ,"1&'....'^:IF64>;:'Outh Errh Inph Proh Thrh'
WaitForSingleObject=. 'kernel32 WaitForSingleObject i x i'&cd
CloseHandle=. 'kernel32 CloseHandle i x'&cd"0
CreateProcess=. 'kernel32 CreateProcessW i x *w x x i  i x x *c *c'&cd
CREATE_NO_WINDOW=. 16b8000000

NB. useful for debugging

CREATE_NEW_CONSOLE =. 16b0000010

NB. may be able to also pass this: CREATE_SUSPENDED =. 16b00000004
f=. CREATE_NO_WINDOW
NB. f=. CREATE_NEW_CONSOLE 
path=. > 0}y
cmd=. > 1}y
c=. uucp path,' ',cmd
si=. (68{a.),67${.a.
pi=. 16${.a.

PROCESSINFO=:  st64 'Proh....Thrh....PridThid'
pi2=. szero PROCESSINFO

'r i1 c i2 i3 i4 f i5 i6 si pi'=. CreateProcess 0;c;0;0;1;f;0;0;si;pi2
ph=. _2 ic 4{.pi
ph=. ptr Proh sget PROCESSINFO pi
th=: ptr Thrh sget PROCESSINFO pi
smoutput 'thread is'
smoutput th
SuspendThread th
NB. CloseHandle ph
ph
)


connectLoop =: 3 : 0
msg =. ''
sdcleanup ''
SKLISTEN =: 0 pick sdcheck sdsocket''
sdcheck sdbind SKLISTEN ; AF_INET_jsocket_ ; '' ; y
sdcheck sdlisten SKLISTEN , 1

wait =: 500  NB. Wait time in milliseconds - this is very arbitrary.

while. msg -.@:-: 'exit' do.
  while. ((3$a:) -: sdc =. sdcheck sdselect SKLISTEN;'';'';wait) do. 
      Sleep wait NB. not sure why the wait isn't blocking above. At one point it was
  end.
  smoutput 'Connected.'
  skserver=: 0 pick sdcheck sdaccept SKLISTEN
  pid =: forkj 'jconsole.exe';'spawn.ijs'
  sddupe skserver;pid
end.
)

NB. 'jconsole needs to be in your path'
NB. uncomment CREATE_NEW_CONSOLE to see the spawned J session
connectLoop 1500



