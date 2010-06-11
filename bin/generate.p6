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
	#say @lines.perl;
	return '' if not @lines;
	
	my $slide = '        <div class="slide">' ~ "\n";
	my $type;
	my @par;
	while @lines {
		my $line = @lines.shift;
		if $line ~~ m/^\=title\s+  (.*)/ {
			$slide ~= '<h1>' ~ $0 ~ '</h1>';
		} elsif $line ~~ m/^\=(\w.*)/ {
			my $newtype = $0;
			$slide ~= section($type, @par);
			$type = $newtype;
			@par = ();
		} else {
			push @par, $line;
		}
		#die "invalid entry";
	}
	if @par {
		$slide ~= section($type, @par);
	}
	$slide ~= "        </div>\n";

	return $slide;
}


sub section($type, @par) {
	return if not @par.join('');
	my $slide = '';
	given $type {
		when 'middle' {
			$slide ~= '<div class="section">';
			$slide ~= '  <div class="middle">';
			$slide ~= '    <h1 class="huge">' ~ @par.join("\n") ~ '</h1>';
			$slide ~= '  </div>';
			$slide ~= '</div>';
		}
		when 'code perl6' {
			$slide ~= "<pre class=\"sh_perl\">\n";
			$slide ~= @par.join("\n");
			$slide ~= "</pre>\n";
		}
		when 'ul' {
			#<em class="attention">
	#say @par.perl;
	#say @par.grep(m/\S/).perl;
	#say @par.grep(m/\S/).map({"<li>{$_}</li>"}).perl;
			$slide ~= "<ul>\n";
			$slide ~= @par.grep(m/\S/).map({"<li>{$_}</li>"}).join("\n");
			$slide ~= "</ul>\n";
		}
		when 'pre' {
			$slide ~= "<pre>\n";
			$slide ~= @par.join("\n");
			$slide ~= "</pre>\n";
		}
		default {
			$slide ~= "<pre>\n";
			$slide ~= @par.join("\n");
			$slide ~= "</pre>\n";
		}
	}
	return $slide;
}


sub usage($msg?) {
	if $msg {
		say $msg;
		say "-----"
	}
	say "Usage: $*PROGRAM_NAME infile";
	exit;
}