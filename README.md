j-fork-server
=============
Proof of concept for spawning J processes from a master process that is listening on a socket. 

1. The server listens on a socket (default 1500)
2. When a request comes in, it spawns a suspended jconsole (supplying the spawn.ijs to execute)
3. It then duplicates the socket using WSADuplicateSocket and writes the struct to a file shared.txt
4. It resumes the spawned process which reads from the shared.txt to get the socket handle

__TODO__

Many things

Better way of sharing data the duplicated socket between the process. If two requests come in at the same exact time then it may miss the socket. 
This is only a concern for the brief moment when the process is being spawned since it grabs the socket during the initialization.

J's socket library appears to internally define a structure for holding a socket reference. Therefore, I don't think I can use those methods directly without injecting the socket reference from WSASocket. Need to investigate further
