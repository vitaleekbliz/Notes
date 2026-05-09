#include "Notes/NotesModel.h"

class Application {
public:
	Application() = default;
	~Application() = default;

	int Run(int argc, char* argv[]);
private:
	NotesModel notesModel;
};