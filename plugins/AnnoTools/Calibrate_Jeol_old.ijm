macro "Calibrate Jeol Old" {
//Gets the tag, and parses it to get the pixel size information
//Jeol Old
path = getInfo("image.directory") + getInfo("image.filename");

tag = call("TIFF_Tags.getTag", path, 37000);
mantise = parseFloat(tag);

tag = call("TIFF_Tags.getTag", path, 37001);
tokens = split(tag,",");
exponent = parseInt(tokens[1]);
unit_exp = parseInt(tokens[2]);

muChar = fromCharCode(0xb5);
recChar = fromCharCode(0x207b)+fromCharCode(0xb9);

unit_prefix_array = newArray("n", muChar, "m", "", "k");
unit_exp_array = newArray(recChar, "", "");

unit = unit_prefix_array[exponent/3+3] + "m" + unit_exp_array[unit_exp+1];

setVoxelSize(mantise, mantise, 1, unit);

savePath = getInfo("image.directory") + "cal_" + getInfo("image.filename");
savePath = replace(savePath, "\\", "/");
//run("Bio-Formats Exporter", "save=["+savePath+"] compression=LZW");
saveAs("tiff", savePath);
close();
open(savePath);
exit();
}