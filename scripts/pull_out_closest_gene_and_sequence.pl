#! /usr/bin/perl -w
#
#	Use this program to make tab files for FileMaker
#

	die "Use this program to find the closest gene to a position in the query
Usage: query.final.fixed.gff3_file snp_file \n" unless (@ARGV);
	
chomp (@ARGV);
#add back the missing first line

($gffile, $snpfile) = (@ARGV);

open (IN, "<$snpfile") or die "Can't open $snpfile\n";
while ($line1 = <IN>){
        chomp ($line1);
        next unless ($line1);
	($refpos, $refbase, $qbase, $qposition, $buff, $dist, $R, $Q, $rlen, $qlen, $refcontig, $qcontig)=split("\t", $line1);
	$hash{$qposition}++;
}
close (IN);

open (IN, "<$gffile") or die "Can't open $gffile\n";
while ($line1 = <IN>){
	chomp ($line1);
	next unless ($line1);
	($contig, $period, $region, $start, $stop, $period2, $plusminus, $period3, $ID)=split ("\t", $line1);
	#see if it is within the gene
	if ($ID){
		next if ($region eq "region");
		foreach $position (sort keys %hash){
			if ($position >= $start && $position <= $stop){
				print "Query SNP position $position within gene: $line1\n";
				$printed{$position}++;
			}
		}
	}
}

close (IN);

foreach $position (sort keys %hash){
	print "No feature found for Query SNP position $position\n" unless ($printed{$position});
	
}

