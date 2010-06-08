use v6;

# Q: can I declare program arguments the same way I can declar sub argumanets?

@*ARGS or usage();

my ($infile) = @*ARGS;
#say "Processing $infile";

my $content = slurp "templates/top.tmpl";

# Q: why does this not blow up?
# if ($line ~~ m/TITLE: (.*)/) {

my @data;
for lines($infile) -> $line {
	if ($line ~~ m/TITLE\:\s*   (.*)/) {
		#say $0;
		$content ~~ s/TMPL_TITLE/$0/;
		next;
	}

	if $line ~~ m/^\=\=\=/ {
		$content ~= process_slide(@data);
		@data    = ();
		next;
	}
	@data.push($line);
	#say $line;
}

$content ~= process_slide(@data);
$content ~= slurp "templates/bottom.tmpl";

my $out = open "out.html", :w;
$out.say($content);

sub process_slide(@lines) {
	say @lines.perl;
	return '' if not @lines;
	
	my $slide = '        <div class="slide">' ~ "\n";
	if @lines[0] eq '=middle' {
		$slide ~= '<div class="section">';
		$slide ~= '  <div class="middle">';
                $slide ~= '    <h1 class="huge">' ~ @lines[1] ~ '</h1>';
                $slide ~= '  </div>';
		$slide ~= '</div>';
	} else {
		#die "invalid entry";
	}
	$slide ~= "        </div>\n";

	return $slide;
}

sub usage($msg?) {
	if $msg {
		say $msg;
		say "-----"
	}
	say "Usage: $*PROGRAM_NAME infile";
}