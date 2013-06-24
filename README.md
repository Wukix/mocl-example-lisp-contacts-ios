This is an example iOS app to demonstrate what a mocl application looks like. It is a simple contact list satisfying the CRUD basics (create, read, update, delete).

Note: mocl is required to build this application. It cannot run on its own. But, you can still see what the code looks like without it.

The application works as follows:
* Zach Beane's vecto (actually the Wukix fork) renders the contact list itself, as well as the detail view of each contact.
* The UI navigation and edit form layout is defined using Xcode's Interface Builder.
* Lisp is used to manage the contact data (sorting the list, reader/printer for storage persistence, etc.).
