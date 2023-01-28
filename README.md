# assh

ASSH automates the login process to UNIX servers. It uses gpg-agent to keep a passphrase to a password database file. Thanks to GnuGPG agent there is no need to enter this passphrase and passwords to servers every time the ssh client is used. Once the passphrase is provided, it is kept by gpg-agent for a certain period. You can next remotely log in to servers without being asked for a password. It allows the execution of commands on single or multiple servers and supports some OpenSSH features like port forwarding, proxy connection, and others like port knocking.


### Usage

    assh -man


---

Note: It is still a usable piece of the software, but I do not find time to maintain it anymore. It may not work as designed with the newer version of Perl and other components. 

