https://github.com/zotero/cross-xpdf/blob/master/Dockerfile#L49

gsed -i "/^\s\sfixCommandLine(&argc,/a if(argc!=3 || argv[1][0]=='-' || argv[2][0]=='-') {fprintf(stderr,\"This is a custom xpdf pdfinfo build. Please use the original version!\\\\n%s\\\\n%s\\\\npdfinfo < PDF-file > < output-file > \\\\n\",xpdfVersion,xpdfCopyright ) ; return 1 ; } else {freopen ( argv[argc-1], \"w\", stdout ) ; argc-- ; }" xpdf/pdfinfo.cc

--- xpdf/pdfinfo.cc.orig	2024-05-11 19:11:52.795503000 +0200
+++ xpdf/pdfinfo.cc	2024-05-11 19:12:07.993025000 +0200
@@ -114,6 +114,7 @@ int main(int argc, char *argv[]) {
 
   // parse args
   fixCommandLine(&argc, &argv);
+if(argc!=3 || argv[1][0]=='-' || argv[2][0]=='-') {fprintf(stderr,"This is a custom xpdf pdfinfo build. Please use the original version!\n%s\n%s\npdfinfo < PDF-file > < output-file > \n",xpdfVersion,xpdfCopyright ) ; return 1 ; } else {freopen ( argv[argc-1], "w", stdout ) ; argc-- ; }
   ok = parseArgs(argDesc, &argc, argv);
   if (!ok || argc != 2 || printVersion || printHelp) {
     fprintf(stderr, "pdfinfo version %s [www.xpdfreader.com]\n", xpdfVersion);
