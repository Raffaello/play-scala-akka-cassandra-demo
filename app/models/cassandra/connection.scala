package models.cassandra

import com.datastax.driver.core.SocketOptions
import com.typesafe.config.ConfigFactory
import com.websudos.phantom.dsl._
import scala.collection.JavaConversions._


object Defaults {
  private val cassandraConfig = ConfigFactory.load.getConfig("cassandra")
  val port = cassandraConfig.getInt("port")
  val hosts = cassandraConfig.getStringList("hosts")
  val keyspace = cassandraConfig.getString("keyspace")

  val Connector = ContactPoints(hosts, port)
      .withClusterBuilder(
        _.withCredentials(
          cassandraConfig.getString("username"),
          cassandraConfig.getString("password")
        )
        .withSocketOptions(new SocketOptions().setConnectTimeoutMillis(10000))
      ).keySpace(keyspace)
}

class AppDatabase(val keyspace: KeySpaceDef) extends Database(keyspace)
{

}

object AppDatabase extends AppDatabase(Defaults.Connector)

//trait AppDatabaseProvider extends DatabaseProvider {
//  override val database: AppDatabase = AppDatabase
//}
