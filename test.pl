#!perl

use SOAP::Lite;

my $username = 'a94a5310d4dc937e5e394f033c574e17';
my $partnership_id = $username;
my $passcode = 't#2iUX5*m6!r4Z';
my $client_id = 'CC80';
my $service_username = 'CC80ats';
my $base_url = 'https://test-cbwebservices.castlebranch.com';
my $endpoint = 'https://test-cbwebservices.castlebranch.com/cgi-bin/server/authSoap.php';


# First, create the SOAP connection

my $soap = SOAP::Lite
  -> uri($base_url)
  -> proxy($endpoint);

# Now, authenticate using Liaison's username & password to get a token and a service URL

my $method = SOAP::Data->name('authenticate')->attr({xmlns => $base_url});

my @params = ( SOAP::Data->name(username => $username), 
               SOAP::Data->name(passcode => $passcode) );
 
my $response = $soap->call($method => @params);
my $token = $response->result;   
my $service_url = ($response->paramsout)[0];
 
print "Token: " . $token;
print "\n";
print "Service URL: " . $service_url;
print "\n\n";

# Try and get a list of packages for Liaison using the newly-obtained service URL

$soap = SOAP::Lite
  -> uri($base_url)
  -> proxy($service_url);
  
$method = SOAP::Data->name('cbGetPackages')->attr({xmlns => $base_url});
  
my $header = SOAP::Header->name("token")->value($token);
  
@params = ( SOAP::Data->name(client_id => $client_id) );  
  
$response = $soap->call($method => @params, $header);
my $packages = $response->result;   

print $packages;


    
