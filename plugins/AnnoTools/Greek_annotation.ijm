macro "Greek annotation" {

greek = newArray("alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", "theta",
				 "iota", "kappa", "lambda", "mu", "nu", "xi", "omikron", "pi", "rho",
				 "varsigma", "sigma", "tau", "upsilon", "phi", "chi", "psi", "omega");
				 
Greek = newArray("Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta",
				 "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omikron", "Pi", "Rho",
				 "xxxdummyxxx", "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega");

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

for (i=0; i<greek.length; i++) {
	text = replace(text, "\\\\"+greek[i], fromCharCode(945+i));
	text = replace(text, "\\\\"+Greek[i], fromCharCode(913+i));
}

text = replace(text, "\\^2", fromCharCode(178));
text = replace(text, "\\^3", fromCharCode(179));
text = replace(text, "_1", fromCharCode(8321));
text = replace(text, "_2", fromCharCode(8322));
text = replace(text, "_3", fromCharCode(8323));

if (bold) {
	fface= "bold antialiased"; 
} else {
	fface= "antialiased";
}

setFont("SansSerif", fs, fface);
setColor("white");

Overlay.drawString(text, x, y+h, 0);
Overlay.show;
}