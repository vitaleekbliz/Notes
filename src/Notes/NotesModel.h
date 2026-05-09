#include <QAbstractListModel>
#include <QVector>

struct NoteItem {
	QString title;
	QString content;
	QString date;
};

class NotesModel : public QAbstractListModel
{
	Q_OBJECT
public:
	enum NoteRoles {
		TitleRole = Qt::UserRole + 1,
		ContentRole,
		DateRole
	};

	explicit NotesModel(QObject* parent = nullptr);

	virtual int rowCount(const QModelIndex& parent = QModelIndex()) const override;
	virtual QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
	virtual QHash<int, QByteArray> roleNames() const override;

	Q_INVOKABLE void addNote(const QString& title, const QString& content);
	Q_INVOKABLE void addNote(const QString& title);
	Q_INVOKABLE void removeNote(int index);
	Q_INVOKABLE void moveNotes(int from, int to);

private:
	QVector<NoteItem> m_Notes;
};