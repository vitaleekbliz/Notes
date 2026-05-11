#include "NotesModel.h"

#include <QDateTime>
#include <QSettings>

NotesModel::NotesModel(QObject* parent)
	: QAbstractListModel(parent)
{
	loadFromSettings();

	if (m_Notes.isEmpty())
	{
		addNote("Welcome", "This is your first note.");
	}
}

int NotesModel::rowCount(const QModelIndex& parent) const
{
	return m_Notes.size();
}

QVariant NotesModel::data(const QModelIndex& index, int role) const
{
	if (!index.isValid() || index.row() >= m_Notes.size())
		return QVariant();

	const NoteItem& item = m_Notes[index.row()];
	if (role == TitleRole)
		return item.title;
	if (role == ContentRole)
		return item.content;
	if (role == DateRole)
		return item.date;

	return QVariant();
}

QHash<int, QByteArray> NotesModel::roleNames() const
{
	QHash<int, QByteArray> roles;
	roles[TitleRole] = "title";
	roles[ContentRole] = "content";
	roles[DateRole] = "date";
	return roles;
}

void NotesModel::addNote(const QString& title, const QString& content)
{
	QString currentTime = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm");
	beginInsertRows(QModelIndex(), m_Notes.size(), m_Notes.size());
	m_Notes.append({ title, content, currentTime });
	endInsertRows();

	saveToSettings();
}

void NotesModel::removeNote(int index)
{
	if (index < 0 || index >= m_Notes.size())
		return;

	beginRemoveRows(QModelIndex(), index, index);
	m_Notes.removeAt(index);
	endRemoveRows();

	saveToSettings();
}

void NotesModel::moveNotes(int from, int to)
{
	if (from == to || from < 0 || to < 0 || from >= m_Notes.size() || to >= m_Notes.size())
		return;

	int destination = (to > from) ? to + 1 : to;

	if (beginMoveRows(QModelIndex(), from, from, QModelIndex(), destination))
	{
		m_Notes.move(from, to);
		endMoveRows();
	}

	saveToSettings();
}

bool NotesModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
	if (!index.isValid() || index.row() >= m_Notes.size())
		return false;

	NoteItem& item = m_Notes[index.row()];
	bool changed = false;

	if (role == TitleRole)
	{
		item.title = value.toString();
		changed = true;
	}
	else if (role == ContentRole)
	{
		item.content = value.toString();
		changed = true;
	}

	if (changed)
	{
		emit dataChanged(index, index, { role });
		saveToSettings();
	}
	return changed;
}

void NotesModel::updateNote(int index, const QString& title, const QString& content)
{
	QModelIndex modelIndex = this->index(index);
	setData(modelIndex, title, TitleRole);
	setData(modelIndex, content, ContentRole);
}

void NotesModel::saveToSettings()
{
	QSettings settings("Company", "NotesApp");
	settings.beginWriteArray("notes");
	for (int i = 0; i < m_Notes.size(); ++i)
	{
		settings.setArrayIndex(i);
		settings.setValue("title", m_Notes[i].title);
		settings.setValue("content", m_Notes[i].content);
		settings.setValue("date", m_Notes[i].date);
	}
	settings.endArray();
}

void NotesModel::loadFromSettings()
{
	QSettings settings("Company", "NotesApp");
	int size = settings.beginReadArray("notes");

	if (size > 0)
	{
		beginResetModel(); // Reset the view for a fresh load
		m_Notes.clear();
		for (int i = 0; i < size; ++i)
		{
			settings.setArrayIndex(i);
			NoteItem item;
			item.title = settings.value("title").toString();
			item.content = settings.value("content").toString();
			item.date = settings.value("date").toString();
			m_Notes.append(item);
		}
		endResetModel();
	}
	settings.endArray();
}