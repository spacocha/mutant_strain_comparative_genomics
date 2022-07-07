#! /usr/bin/perl -w
#
#	Use this program to make tab files for FileMaker
#

	die "Use this program to fix the orientation of the gff3 files
Use the output from fix_circulate_fasta_wblast.pl gff3 file and the fasta fixed file
Usage: fixed_gff3_file fixed_fasta \n" unless (@ARGV);
	
chomp (@ARGV);
#add back the missing first line
print "##gff-version 3\n";

($gffile, $fafile) = (@ARGV);

die "Please follow command line requirements\n" unless ($fafile);
#Set up the order for each element
$regionhash{"region"}=1;
$regionhash{"gene"}=2;
$regionhash{"mRNA"}=3;
$regionhash{"tRNA"}=4;
$regionhash{"rRNA"}=5;
$regionhash{"tmRNA"}=6;
$regionhash{"CDS"}=7;
$regionhash{"exon"}=8;
$regionhash{"polypeptide"}=9;

open (IN, "<$gffile") or die "Can't open $gffile\n";
while ($line1 = <IN>){
	chomp ($line1);
	next unless ($line1);
	($contig, $period, $region, $start, $stop, $period2, $plusminus, $period3, $ID)=split ("\t", $line1);
	if ($ID){
		if ($hash{$start}{$stop}{$region}){
			die "Already has this region $line $hash{$start}{$stop}{$region}\n";
		} else {
			$hash{$start}{$stop}{$region}=$line1;
			die "Missing this $region\n" unless ($regionhash{$region});		
		}
	}
	
}
close (IN);

foreach $start (sort {$a <=> $b} keys %hash){
	foreach $stop (sort {$b <=> $a} keys %{$hash{$start}}){
		foreach $region (sort {$regionhash{$a} <=> $regionhash{$b}} keys %regionhash){
			if ($hash{$start}{$stop}{$region}){
				print "$hash{$start}{$stop}{$region}\n";
			}
		}
	}
}

open (IN, "<$fafile") or die "Can't open $fafile\n";
while ($line=<IN>){
	chomp ($line);
	print "$line\n";
}

