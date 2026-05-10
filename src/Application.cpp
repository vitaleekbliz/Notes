#include "Application.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int Application::Run(int argc, char* argv[])
{
	QGuiApplication app(argc, argv);

	QQmlApplicationEngine engine;
	engine.rootContext()->setContextProperty("notesModel", &notesModel);

	QObject::connect(
		&engine,
		&QQmlApplicationEngine::objectCreationFailed,
		&app,
		[]() { QCoreApplication::exit(-1); },
		Qt::QueuedConnection);
	engine.loadFromModule("Notes", "Main");

	return QCoreApplication::exec();
}