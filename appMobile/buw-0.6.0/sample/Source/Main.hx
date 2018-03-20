import openfl.display.Sprite;
import buw.*;

typedef Book = {
	var author : String;
	var title : String;
}

class Main extends Sprite {
	var main : VBox;
	var text : Input;
	
	public function new () {
		super ();
		//Widget.font = "montserrat";
		main = new VBox(1, -1);
		main.pack(new Title("Example title: "));
		main.pack(new TextButton(cbListView, "Load ListView"));
		main.pack(new TextButton(cbTable, "Load Table"));
		main.pack(new TextCheckBox(null, "checkbox", true));
		main.pack(new TextSpinBox(null, "spinbox"));
		var hb1 = new HBox(1, [new HBoxColumn(0.33), new HBoxColumn(0.33), new HBoxColumn(0.33)]);
		main.pack(hb1);
		hb1.pack(new TextButton(null, "Button 1", 0.3));
		hb1.pack(new TextButton(null, "Button 2", 0.3));
		hb1.pack(new TextButton(null, "Button 3", 0.3));
		var hb2 = new HBox(1, [new HBoxColumn(0.5), new HBoxColumn(0.5)]);
		main.pack(hb2);
		hb2.pack(new TextButton(null, "Button 1", 0.4));
		hb2.pack(new TextButton(null, "Button 2", 0.4));
		main.pack(new Separator());
		var g : Grid = new Grid(1, [new HBoxColumn(0.3), new HBoxColumn(0.7)]);
		g.pack(new Label("Firstname:"));
		g.pack(new Input("", 20, 0.6));
		g.pack(new Label("Lastname:"));
		g.pack(new Input("", 20, 0.6));
		main.pack(g);
		Screen.display(main);
	}

	function cbListView(w : Control) {
		main.pack(new Separator());
		var books : Array<Book> = new Array();
		books.push({title : "Les misérables", author : "Victor Hugo"});
		books.push({title : "20 000 lieues sous les mers", author : "Jules Verne"});
		var list : ListView<Book> = new ListView(function(o : Book) : Widget { return new Label(o.title + " - " + o.author); },
			function (o : Book) { trace(o.title); });
		list.source = books;
		main.pack(list);
	}

	function cbTable(w : Control) {
		main.pack(new Separator());
		var books : Array<Book> = new Array();
		books.push({title : "La Horde du contrevent", author : "Alain Damasio"});
		books.push({title : "La fraternité du Panca", author : "Pierre Bordage"});
		var table : Table<Book> = new Table(function (o : Book) { trace(o.title); }, 1, 
			[new TableColumn(0.65, "Title", "title"), new TableColumn(0.35, "Author", "author")]);
		table.source = books;
		main.pack(table);
	}
}
