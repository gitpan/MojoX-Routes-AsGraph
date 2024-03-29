#!perl

use strict;
use warnings;
use Test::More tests => 1;

use MojoX::Routes;
use MojoX::Routes::AsGraph;

### The top level container
my $r = MojoX::Routes->new;

### A couple of simple paths
$r->route('/')->to( controller => 'site', action => 'homepage')->name('Homepage' );
$r->route('/about')->to( controller => 'site', action => 'about')->name('About');

### check for long lived cookies for username hints; also check for authed users
my $user_sniffer = $r->bridge->to(controller => 'auth', action => 'sniff_user');

### homepage
$user_sniffer->route('/')->to(controller => 'dashboard', action => 'home');

### Login doesn't require auth but login might like to sniff the user
$user_sniffer->route('/login')->to(controller => 'auth', action => 'login');
$user_sniffer->route('/logout')->to(controller => 'auth', action => 'logout');

### Auth zone
my $is_authed = $user_sniffer->bridge->to(controller => 'auth', action => 'require_user' );

### My restricted area
my $home = $is_authed->route('/home')->to(controller => 'member_area');
$home->route()->to( action => 'index' );
$home->route('/profile')->to(action => 'profile');

### Ok, lets draw this
my $graph = MojoX::Routes::AsGraph->graph($r);
is($graph->as_txt, <<'...');
[  <empty 1> ] --> [  \[auth->sniff_user\] ]
[  <empty 1> ] --> [ * '/' \[site->homepage\] (Homepage) ]
[  <empty 1> ] --> [ * '/about' \[site->about\] (About) ]
[  \[auth->sniff_user\] ] --> [  \[auth->require_user\] ]
[  \[auth->sniff_user\] ] --> [ * '/' \[dashboard->home\] ]
[  \[auth->sniff_user\] ] --> [ * '/login' \[auth->login\] ]
[  \[auth->sniff_user\] ] --> [ * '/logout' \[auth->logout\] ]
[  \[auth->require_user\] ] --> [  '/home' \[member_area\] ]
[  '/home' \[member_area\] ] --> [ * '/profile' \[->profile\] ]
[  '/home' \[member_area\] ] --> [ * \[->index\] ]
...


