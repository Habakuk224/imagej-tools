macro "Calibrate Jeol Old" {
	
// Gets the tag, and parses it to get the pixel size information
// Jeol Old

recChar = fromCharCode(0x207b)+fromCharCode(0xb9);

path = getInfo("image.directory") + getInfo("image.filename");

run("Bio-Formats Macro Extensions");
Ext.setId(path);
Ext.getPixelsPhysicalSizeX(pixelSize) // pixel size in um (imaging) or 1/um (diffraction)
Ext.getMetadataValue("Camera name",mode)

getDimensions(width, height, channels, slices, frames);
sizeParam = width/1024;

if (mode == "Diff") {
	pixelSize = pixelSize * 1e3; // pixel size in 1/um -> 1/nm
	unit = "nm" + recChar;
} else {
	if (mode == "Mag") {
		if (200*pixelSize*sizeParam > 0.8) {
			unit = "um";
		} else {
			pixelSize = pixelSize * 1e3; // pixel size um -> nm
			unit = "nm";
		}		
	} else {
		exit("Unknown camera mode");
	} 
}

setVoxelSize(pixelSize, pixelSize, 1, unit);

savePath = getInfo("image.directory") + "cal_" + getInfo("image.filename");
savePath = replace(savePath, "\\", "/");
//run("Bio-Formats Exporter", "save=["+savePath+"] compression=LZW");
saveAs("tiff", savePath);
close();
open(savePath);
exit();
}