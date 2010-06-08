use v6;

# Q: can I declare program arguments the same way I can declar sub argumanets?

@*ARGS or usage();

my ($infile) = @*ARGS;
#say "Processing $infile";

my $content = slurp "templates/top.tmpl";

# Q: why does this not blow up?
# if ($line ~~ m/TITLE: (.*)/) {

for lines($infile) -> $line {
	if ($line ~~ m/TITLE\:\s*   (.*)/) {
		#say $0;
		$content ~~ s/TMPL_TITLE/$0/;
	}
	#say $line;
}

$content ~= slurp "templates/bottom.tmpl";

my $out = open "out.html", :w;
$out.say($content);
  
sub usage($msg?) {
	if $msg {
		say $msg;
		say "-----"
	}
	say "Usage: $*PROGRAM_NAME infile";
}