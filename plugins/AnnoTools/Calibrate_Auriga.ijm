macro "Calibrate Auriga" {
//Gets the tag, and parses it to get the pixel size information
//Zeiss Auriga
path = getInfo("image.directory") + getInfo("image.filename");

run("TIFF Dumper");
tag = getInfo("log");
selectWindow("Log");
run("Close");

i0 = indexOf(tag, "AP_IMAGE_PIXEL_SIZE");
if (i0==-1) exit ("Scale information not found");
i1 = indexOf(tag, "=", i0);
i2 = indexOf(tag, "AP", i1);

if (i1==-1 || i2==-1 || i2 <= i1+3)
   exit ("Parsing error! Maybe the file structure changed?");
text = substring(tag,i1+2,i2-2);

//Splits the pixel size in number+unit
//and sets the scale of the active image
tokens = split(text," ");
mantise = parseFloat(tokens[0]);
unit = tokens[1];

if (unit=="nm")
	exponent = -9;
else if (unit=="um" || unit=="µm")
	exponent = -6;
else
	exit ("Unknown unit.");

getDimensions(width, height, channels, slices, frames);
sizeParam = width/1024;

pixelSize = mantise*pow(10,exponent);

if (200*pixelSize*sizeParam < 1e-6)
	setVoxelSize(pixelSize*1e9, pixelSize*1e9, 1, "nm");
else
	setVoxelSize(pixelSize*1e6, pixelSize*1e6, 1, "um");

savePath = getInfo("image.directory") + "cal_" + getInfo("image.filename");
savePath = replace(savePath, "\\", "/");
//run("Bio-Formats Exporter", "save=["+savePath+"] compression=LZW");
saveAs("tiff", savePath);
close();
open(savePath);
exit();
}