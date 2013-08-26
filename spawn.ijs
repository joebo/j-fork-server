load 'socket'
WSASocket=: 'ws2_32 WSASocketW i i i i *c i i' & cd
Sleep=:'kernel32 Sleep n i' & cd
sendJ=: 'ws2_32 send i i *c i i'

binarr  =: 3!:2
Z =: fread 'shared.txt'
sockh =: WSASocket _1;_1;_1;(binarr Z);0;0
smoutput sockh
sock =: > 0}sockh 
T=:'hi',CRLF
wait =: 500  NB. Wait time in milliseconds - this is very arbitrary.


sendJ cd 4;T;(#T);0

messageLoop =: 3 : 0
msg =. ''
while. msg -.@:-: 'exit' do.
sendJ cd sock;T;(#T);0
Sleep 500
end.
)

messageLoop ''
