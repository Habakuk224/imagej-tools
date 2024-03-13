macro "Calibrate Quanta" {
//Gets the tag, and parses it to get the pixel size information
//FEI Quanta
path = getInfo("image.directory") + getInfo("image.filename");

run("TIFF Dumper");
tag = getInfo("log");
selectWindow("Log");
run("Close");

i0 = indexOf(tag, "PixelWidth=");
if (i0==-1) exit ("Scale information not found");
i1 = indexOf(tag, "=", i0);
i2 = indexOf(tag, "\n", i1);
if (i1==-1 || i2==-1 || i2 <= i1+3)
   exit ("Parsing error! Maybe the file structure changed?");
text = substring(tag,i1+1,i2-1);

//Splits the pixel size in number+unit
//and sets the scale of the active image
tokens = split(text,"e");
mantise = parseFloat(tokens[0]);
exponent = parseInt(tokens[1]);

pixelSize = mantise*pow(10,exponent);

getDimensions(width, height, channels, slices, frames);
sizeParam = width/1024;

if (200*pixelSize*sizeParam < 1e-6)
	setVoxelSize(pixelSize*1e9, pixelSize*1e9, 1, "nm");
else
	setVoxelSize(pixelSize*1e6, pixelSize*1e6, 1, "um");
	
makeRectangle(0, 0, width, sizeParam*883);
run("Crop");

savePath = getInfo("image.directory") + "cal_" + getInfo("image.filename");
savePath = replace(savePath, "\\", "/");
//run("Bio-Formats Exporter", "save=["+savePath+"] compression=LZW");
saveAs("tiff", savePath);
close();
open(savePath);
exit();
}