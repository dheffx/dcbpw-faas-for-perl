use strict;

# usage: 
#   ./generate-files.pl outdir
#   aws s3 sync outdir/ s3://your-upload-bucket/landing
#   rm -rf outdir
#   aws s3 ls s3://your-upload-bucket/processed

my $out = shift @ARGV || "/tmp/s3-test";
for (1..500) {
    my @chars = ("A".."Z", "a".."z");
    my $filename;
    $filename .= $chars[rand @chars] for 1..8;
    open my $fh, ">", "$out/$filename" or die "cannot open $out/$filename: $_";
    print $fh "exampledata\n";
    close $fh;
}
