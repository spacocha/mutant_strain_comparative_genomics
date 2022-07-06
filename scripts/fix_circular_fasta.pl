#! /usr/bin/perl -w
#
#	Use this program to make tab files for FileMaker
#

	die "Use this program to re-organize a circular genome around a cut-point
	Provide the new base position (from blast) that you would like as the first base
	Usage: input_file cut-point > Redirect output\n" unless (@ARGV);
	
	chomp (@ARGV);
	($file, $cutpoint) = (@ARGV);
	$/ = ">";
	$cutpoint-=2;
	open (IN, "<$file") or die "Can't open $file\n";
	while ($line1 = <IN>){	
		chomp ($line1);
		next unless ($line1);
		$sequence = ();
		(@pieces) = split ("\n", $line1);
		($info) = shift (@pieces);
		($sequence) = join ("", @pieces);
		$sequence =~tr/\n//d;
		#die "$sequence\n";
		(@bases)=split("", $sequence);
		$end=@bases;
		#die "$end\n";
		($newend)=join("", @bases[1..$cutpoint]);
		$cutpoint++;
		$end--;
		($newstart)=join("", @bases[$cutpoint..$end]);
		#die "$newend\n";
		print ">$info\n${newstart}${newend}\n";

	}
	
	close (IN);

	
