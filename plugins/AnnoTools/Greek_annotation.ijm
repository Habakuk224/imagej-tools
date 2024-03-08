macro "Greek annotation" {
alfa = fromCharCode(945);
beta = fromCharCode(946);
tau = fromCharCode(964);
omega = fromCharCode(969);

sub2 = fromCharCode(8322);

col_num = newArray("2", "1");

Dialog.create("Add greek");
  	Dialog.addRadioButtonGroup("Columns", col_num, 1, 2, "2");
  
  	Dialog.addString("Text:", "");
	Dialog.addCheckbox("Bold", true);
	
 	Dialog.show();
 	
  	cols = parseInt(Dialog.getRadioButton());
  	text = Dialog.getString();
  	bold = Dialog.getCheckbox();

getDimensions(width, height, channels, slices, frames);
col_factor = cols/2;
sizeParam = width/1024;
fs = floor(48*sizeParam*col_factor);

getSelectionBounds(x, y, w, h)

text = replace(text, "\\\\a", alfa);
text = replace(text, "\\\\b", beta);
text = replace(text, "\\\\t", tau);
text = replace(text, "\\\\w", omega);
text = replace(text, "_2", sub2);

setFont("SansSerif",fs,"bold antialiased");
setColor("white");

Overlay.drawString(text, x, y+h, 0);
Overlay.show;
}