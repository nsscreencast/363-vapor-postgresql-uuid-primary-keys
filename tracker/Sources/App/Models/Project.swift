import Vapor
import FluentPostgreSQL

final class Project : Model {
    typealias ID = UUID
    typealias Database = PostgreSQLDatabase
    
    static var idKey: IDKey = \.id
    
    static var name: String = "projects"
    
    var id: UUID?
    var title: String
    var description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

extension Project : Migration {
    static func prepare(on conn: Database.Connection) -> Future<Void> {
        return PostgreSQLDatabase.create(self, on: conn) { builder in
            
            let pk = PostgreSQLColumnConstraint.primaryKey(default: nil, identifier: nil)
            let defaultUUID = PostgreSQLColumnConstraint.default(.function("uuid_generate_v4"), identifier: nil)
            builder.field(for: \.id, type: .uuid, pk, defaultUUID)
            builder.field(for: \.title, type: .varchar(500))
            builder.field(for: \.description)
        }
    }
}
