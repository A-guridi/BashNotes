# PING
## Test connectivity and measure latency
ping hostname.com
-c N          : stop after sending N packets (default: infinite on Linux)
-i interval   : wait interval seconds between packets (default: 1)
-W timeout    : timeout in milliseconds waiting for a response
-s size       : data size in bytes (default: 56, total 84 with ICMP header)

# Examples
ping -c 4 google.com                    # send 4 packets and stop
ping -c 10 -i 0.5 8.8.8.8              # rapid ping, 10 packets, 0.5s interval
ping -c 5 -W 2000 unreachable.host     # timeout after 2 seconds per packet


# NSLOOKUP / DIG
## DNS query tools (dig is more powerful for detailed queries)
nslookup hostname.com                   # simple A record lookup
nslookup -type=MX example.com           # lookup mail exchange records
dig hostname.com                        # detailed DNS query output
dig @8.8.8.8 example.com                # query specific nameserver
dig example.com +short                  # short output format
dig +trace example.com                  # show full DNS resolution path

# Examples
nslookup github.com                     # returns IP(s)
dig github.com MX +short                # email servers for domain
dig @1.1.1.1 example.com CNAME          # query Cloudflare DNS for CNAME
dig -x 8.8.8.8                          # reverse DNS lookup
dig example.com +noall +answer          # show only answer section


# CURL / WGET
## Download files and make HTTP requests
curl [options] URL
wget [options] URL

# Common curl flags
-X METHOD     : HTTP method (GET, POST, PUT, DELETE, etc.)
-d data       : POST data (form-encoded or JSON)
-H header     : add custom header
-i            : include HTTP response headers in output
-I            : fetch headers only (HEAD request)
-u user:pass  : HTTP basic authentication
-b cookie     : send cookie
-c file       : save cookies to file
-o file       : save output to file (keep original filename)
-O            : save with original filename
-L            : follow redirects
-v            : verbose (show request/response details)
-m seconds    : timeout after N seconds

# Examples
curl -X GET https://api.github.com/users/octocat
curl -X POST -d "param1=value1&param2=value2" https://example.com/api
curl -H "Authorization: Bearer TOKEN" -H "Content-Type: application/json" https://api.example.com
curl -d @data.json -H "Content-Type: application/json" https://api.example.com/post
curl -u user:password https://httpbin.org/basic-auth/user/password
curl -L -o downloaded_file.zip https://example.com/redirect/to/file.zip
curl -I https://example.com                  # headers only
curl -v https://example.com 2>&1 | grep ">"  # show only request headers


# WGET
## Download files with better resuming capabilities
wget URL
-O filename   : save with specific filename
-c            : resume interrupted download
-q            : quiet (no output)
-O -          : output to stdout
--spider      : check if URL exists without downloading
--limit-rate  : limit bandwidth
--timeout     : timeout in seconds

# Examples
wget https://example.com/largefile.zip       # simple download
wget -c https://example.com/largefile.zip    # resume if interrupted
wget -q -O - https://example.com/data.json   # fetch and pipe to stdout


# NETSTAT / SS
## Network statistics and active connections
netstat -tuln    : listening TCP/UDP sockets (-t TCP, -u UDP, -l listen, -n numeric)
netstat -an      : all connections with numeric addresses
netstat -antp    : all connections with process info (needs sudo)
netstat -i       : interface statistics

ss -tuln         : modern replacement, more efficient
ss -antp         : all connections with process info
ss -s            : summary statistics
ss -tp           : show TCP connections with process names

# Examples
sudo netstat -antp | grep ESTABLISHED            # all established connections with PIDs
ss -tuln | grep LISTEN                           # listening ports only
sudo ss -antp | grep ':8080'                     # find process using port 8080
netstat -an | grep TIME_WAIT | wc -l             # count TIME_WAIT connections
sudo ss -antp | grep ssh                         # SSH connections


# IP / IFCONFIG
## Configure and query network interfaces
ifconfig                                 # show all interfaces (deprecated, use 'ip')
ifconfig eth0                            # show specific interface
ip addr show                             # show all interfaces and addresses
ip addr show eth0                        # show specific interface
ip link show                             # show link-level info (MAC, MTU, etc.)
ip route show                            # show routing table
ip route add default via 192.168.1.1     # add default route (requires sudo)

# Common operations
ifconfig eth0 down/up                    # disable/enable interface
ip link set eth0 up/down                 # enable/disable with ip command
ifconfig eth0 192.168.1.100              # set static IP (requires sudo)
ip addr add 192.168.1.100/24 dev eth0    # add IP address

# Examples
ip addr show | grep inet                 # show all IP addresses only
ip route show | grep default              # show default gateway
sudo ip route del default                # remove default route
ip link show | grep "^[0-9]"             # show interface names only


# NC / NETCAT
## Network utility for reading/writing across sockets
nc -l port                   : listen on port
nc -zv host port             : test if port is open (-z no data, -v verbose)
nc host port                 : connect to host:port
nc -u host port              : UDP instead of TCP
nc -L port                   : listen and restart after disconnect

# Examples
nc -zv google.com 443                    # test if HTTPS port is open
nc -zv 192.168.1.1 22-25                 # test port range
echo "test data" | nc localhost 8080     # send data to port 8080
nc -l 9999 < file.txt                    # send file to anyone who connects
nc -u -l 5000                            # listen on UDP port 5000


# TRACEROUTE / MPATH
## Trace network path to destination
traceroute host                          # show hops to destination
mtr host                                 # interactive traceroute with statistics
traceroute -m max_hops host              # set max hop limit (default: 30)
traceroute -n host                       # don't resolve hostnames (faster)

# Examples
traceroute google.com                    # trace route to Google
mtr -r -c 100 8.8.8.8                    # run MtR 100 cycles, report format
traceroute -m 15 192.168.1.1             # limit to 15 hops


# SSH / SCP
## Secure shell and secure copy
ssh user@host                            # connect to remote host
ssh -p port user@host                    # connect to specific port
ssh -i keyfile user@host                 # use specific private key
ssh -X user@host                         # enable X11 forwarding
ssh -N -L local_port:dest_host:dest_port user@host  # local port forwarding
ssh -v user@host                         # verbose (debug connection)
ssh user@host 'command'                  # execute remote command

scp source destination                   # copy between local and remote
scp -r user@host:/path/dir ./            # copy directory recursively
scp -P port file user@host:/path/        # use non-standard port

# Examples
ssh user@192.168.1.100
ssh -p 2222 admin@example.com            # non-standard SSH port
ssh -i ~/.ssh/id_rsa ubuntu@ec2.aws.com
ssh user@host 'ps aux | grep process'    # run command remotely and see output
scp -r user@host:/data ./backup/         # backup remote directory
ssh -N -L 8080:localhost:3306 user@host  # forward remote MySQL port locally
ssh user@host 'tar czf - /path' | tar xzf -  # pipe remote tar to local extraction


# ARP
## Address Resolution Protocol - map IP to MAC addresses
arp                              : show ARP table
arp -a                          : show all ARP entries
arp -a hostname                 : ARP entry for specific host
arp -d address                  : delete ARP entry (requires sudo)
arp -s address mac              : set static ARP entry (requires sudo)
ip neigh show                   : modern replacement (show neighbors)

# Examples
arp                                      # show ARP table
arp -a | grep 192.168.1                  # ARP entries for specific subnet
ip neigh show                            # show all neighbors (better format)
ip neigh show dev eth0                   # neighbors on specific interface


# ROUTE
## Manage routing table
route                           : show routing table
route -n                        : show with numeric addresses (faster)
ip route show                   : modern replacement
route add default gw gateway    : add default route (requires sudo)
route del default                : delete default route
route add -net network netmask gateway  : add network route

# Examples
route -n | grep default                  # show default gateway
sudo route add default gw 192.168.1.1    # set default gateway
ip route show | grep via                 # show routes with gateway


# IPTABLES
## Linux firewall configuration
iptables -L                     : list all rules
iptables -L -n                  : list with numeric addresses
iptables -A INPUT -p tcp --dport 22 -j ACCEPT  : allow incoming SSH
iptables -A INPUT -j DROP       : set default policy
iptables -D INPUT 1             : delete rule number 1
iptables -F                     : flush all rules

# Common policies
-A              : append rule
-I              : insert rule
-D              : delete rule
-p protocol     : tcp, udp, icmp
--dport port    : destination port
--sport port    : source port
-j action       : ACCEPT, DROP, REJECT, REDIRECT

# Examples
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT    # allow HTTP
sudo iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT    # allow subnet
sudo iptables -A INPUT -j DROP                        # set default to DROP
sudo iptables -L -n                                    # show rules
sudo iptables -F                                       # clear all rules


# Useful combinations and one-liners

# Check which process is listening on port 8080
sudo lsof -i :8080

# Monitor network traffic in real-time
sudo tcpdump -i eth0 -n 'tcp port 80'

# Show bandwidth usage per interface
ifstat -i eth0

# Test DNS resolution across multiple servers
for ns in 8.8.8.8 1.1.1.1 208.67.222.222; do echo "Testing $ns:"; dig @$ns google.com +short; done

# Port scan using curl (check if ports are open)
for port in 80 443 8080 8443; do timeout 1 bash -c "echo > /dev/tcp/example.com/$port" && echo "Port $port open" || echo "Port $port closed"; done

# Get external IP address
curl -s https://ifconfig.co

# Monitor connections in real-time
watch -n 1 'ss -antp | grep ESTABLISHED | wc -l'

# Measure latency percentiles
ping -c 100 google.com | tail -1

# Find all open ports on local machine
ss -tuln | grep LISTEN
