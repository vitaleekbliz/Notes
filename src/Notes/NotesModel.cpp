#include "NotesModel.h"

#include <QDateTime>

NotesModel::NotesModel(QObject* parent) : QAbstractListModel(parent) {
	// TODO(8BiT): remove debug data
	addNote("LeetCode 75", "Finish the sliding window section.");
	addNote("Qt Project", "Implement the C++ model for the team.");
}

int NotesModel::rowCount(const QModelIndex& parent) const {
	return m_Notes.size();
}

QVariant NotesModel::data(const QModelIndex& index, int role) const {
	if (!index.isValid() || index.row() >= m_Notes.size())
		return QVariant();

	const NoteItem& item = m_Notes[index.row()];
	if (role == TitleRole) return item.title;
	if (role == ContentRole) return item.content;
	if (role == DateRole) return item.date;

	return QVariant();
}

QHash<int, QByteArray> NotesModel::roleNames() const {
	QHash<int, QByteArray> roles;
	roles[TitleRole] = "title";
	roles[ContentRole] = "content";
	roles[DateRole] = "date";
	return roles;
}

void NotesModel::addNote(const QString& title, const QString& content) {
	QString currentTime = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm");
	beginInsertRows(QModelIndex(), m_Notes.size(), m_Notes.size());
	m_Notes.append({ title, content, currentTime });
	endInsertRows();
}

Q_INVOKABLE void NotesModel::addNote(const QString& title)
{
	QString currentTime = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm");
	beginInsertRows(QModelIndex(), m_Notes.size(), m_Notes.size());
	m_Notes.append({ title, QString(), currentTime });
	endInsertRows();
}

void NotesModel::removeNote(int index) {
	if (index < 0 || index >= m_Notes.size()) return;

	beginRemoveRows(QModelIndex(), index, index);
	m_Notes.removeAt(index);
	endRemoveRows();
}

Q_INVOKABLE void NotesModel::moveNotes(int from, int to)
{
	if (from == to || from < 0 || to < 0 ||
		from >= m_Notes.size() || to >= m_Notes.size()) return;

	int destination = (to > from) ? to + 1 : to;

	if (beginMoveRows(QModelIndex(), from, from, QModelIndex(), destination)) {
		m_Notes.move(from, to);
		endMoveRows();
	}
}
