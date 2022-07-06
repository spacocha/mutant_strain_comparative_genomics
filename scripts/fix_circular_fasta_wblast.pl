#! /usr/bin/perl -w
#
#	Use this program to make tab files for FileMaker
#

	die "Use this program to re-organize a circular genome around a cut-point
Use both forward and reverse complement blast reports to choose how to reorient the genome
Usage: foward_fasta rc_fasta fwd_blast rc_blast gff3_file genome_length output_prefix\n" unless (@ARGV);
	
chomp (@ARGV);
($ffile, $rcfile, $fblastfile, $rcblastfile, $gfile, $glength, $output_prefix) = (@ARGV);
open (IN, "<$fblastfile") or die "Can't open $fblastfile\n";
while ($line1 = <IN>){
	chomp ($line1);
	next unless ($line1);
	($qseqid, $sseqid, $pident, $length, $mismatch, $gapopen, $qstart, $qend, $sstart, $send, $eval, $bit)=split ("\t", $line1);
	if ($sstart eq 1){
		#length check makes sure it's not just a short stretch of similarity that happens to start at
		#this is the first position of the reference
		#Check if query is in the right orientation
		#die "$qstart $sstart\n";
		if ($qstart < $qend && $sstart < $send){
			#both are increasing
			$fcutpoint=$qstart;
		}
	}
	last if ($fcutpoint);
}
close (IN);

open (IN, "<$rcblastfile") or die "Can't open $rcblastfile\n";
while ($line1 = <IN>){
        chomp ($line1);
        next unless ($line1);
        ($qseqid, $sseqid, $pident, $length, $mismatch, $gapopen, $qstart, $qend, $sstart, $send, $eval, $bit)=split ("\t", $line1);
        if ($sstart eq 1){
                #length check makes sure it's not just a short stretch of similarity that happens to start at
                #this is the first position of the reference
                #Check if query is in the right orientation
		#die "$qstart $qend $sstart $send\n";
                if ($qstart < $qend && $sstart < $send){
                        #both are increasing
                        $rccutpoint=$qstart;
                }
        }
        last if ($rccutpoint);
}
close (IN);

#die "FCUT $fcutpoint RCUT $rccutpoint\n";

if ($fcutpoint){
	if ($rccutpoint){
		#both have good cutpoints, so I'm not sure what to do about it
		die "Found two good cutpoints in blast\n";
	} else {
		$cutpoint = $fcutpoint;
		#forward file is the right one to use
		$file=$ffile;
		$orient="forward";
	}
} elsif ($rccutpoint) {
	$cutpoint=$rccutpoint;
	#rc is the right file
	$file=$rcfile;
	$orient="reverse_comp";
} else {
	die "Can't find a good cutpoint in the blast reports\n";
}
#die "$orient\n";
#Fix the gff file according to the cut-point and the orientationi
open (OUT, ">${output_prefix}.gff3") or die "Can't open ${output_prefix}.gff3\n";
open (IN, "<$gfile") or die "Can't open $gfile\n";
while ($line1 = <IN>){
	chomp ($line1);
	next unless ($line1);
	if ($line1=~/^#/){
		#print "$line1\n";
	} else {
		($contig, $period, $type, $start, $stop, $period2, $plusminus, $period3, $ID)=split ("\t",$line1);
		#die "Missing $contig $period $type $start $stop $period2 $plusminus $period3 $ID\n" unless ($ID);
		#just print out anything missing ID, since it's probably the end sequence (although it would have to be the RC!
		if ($ID){
			$newstart_tmp = $glength - $start + 1;
			$newstop_tmp = $glength - $stop + 1;
			if ($orient eq "reverse_comp"){
				#These need to be reverse complemented and shifted
				#print "$ID\n";
				#rc formula
				#die "Oldstart $start Old stop $stop Newstart $newstart newstop $newstop $ID\n" if ($ID =~/ArcA/);
				if ($newstart_tmp > $newstop_tmp){
					$newstart=$newstop_tmp;
					$newstop=$newstart_tmp;
				} else {
					$newstart=$newstart_tmp;
					$newstop=$newstop_tmp;
				}
				print OUT "$contig\t$period\t$type\t$newstart\t$newstop\t$period2\t";
				if ($plusminus eq "+"){
					print OUT "-";
				} else {
					print OUT "+";
				}
				print OUT "\t$period3\t$ID\n";

			} else {
				#Just need to shift by specific number of bases
				print OUT "$contig\t$period\t$type\t${newstart_tmp}\t${newstop_tmp}\t$period2\t$plusminus\t$period3\t$ID\n";
			}
		}
	}
}
close (IN);

open (OUT2, ">${output_prefix}.fasta") or die "Can't open ${output_prefix}.fasta\n";

#Fix the fasta file according to cut and orientation
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
		print OUT2 ">$info\n${newstart}${newend}\n";
		print OUT ">$info\n${newstart}${newend}\n";
	}
	
	close (IN);

	
