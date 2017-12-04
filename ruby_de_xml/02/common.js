function make_function_list()
{
	if (document.getElementsByTagName) {
		var elems = document.getElementsByTagName("code");
		var ul = document.createElement("ul");
		var i;
		for (i = 0; i < elems.length; i++) {
			var id = elems.item(i).getAttribute("id");
			if (id == null || id == "") {
				id = "__content__" + i.toString(10);
				elems.item(i).setAttribute("id", id);
				elems.item(i).setAttribute("name", id);
			}

			var a = document.createElement("a");
			a.setAttribute("href", "#" + id);
			var text = get_textdata(elems.item(i));
			a.appendChild(document.createTextNode(text));
			var li = document.createElement("li");
			li.appendChild(a);
			ul.appendChild(li);
		}

		var h2 = document.body.getElementsByTagName("h2").item(0);
		
		var contents = document.createElement("h2");
		contents.appendChild(document.createTextNode("ŠÖ”ˆê——"));
		document.body.insertBefore(contents, h2);
		document.body.insertBefore(ul, h2);

	}
}

function get_textdata(node) 
{
	var text = "";
	var children = node.childNodes;
	var i;
	for (i = 0; i < children.length; i++) {
		if (children.item(i).hasChildNodes()) {
			text += get_textdata(children.item(i));
		} else {
			text += children.item(i).data;
		}
	}
	return(text);
}
