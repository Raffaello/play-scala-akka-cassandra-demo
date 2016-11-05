package models.cassandra

import com.datastax.driver.core.SocketOptions
import com.typesafe.config.ConfigFactory
import com.websudos.phantom.dsl._
import io.surfkit.gremlin.GremlinClient

import scala.collection.JavaConversions._

object Defaults
{
  private val _cassandraConfig = ConfigFactory.load.getConfig("cassandra")
  val port = _cassandraConfig.getInt("port")
  val hosts = _cassandraConfig.getStringList("hosts")
  val keyspace = _cassandraConfig.getString("keyspace")

  val cassandraConfig = ContactPoints(hosts, port)
      .withClusterBuilder(
        _.withCredentials(
          _cassandraConfig.getString("username"),
          _cassandraConfig.getString("password")
        )
        .withSocketOptions(new SocketOptions().setConnectTimeoutMillis(10000))
      ).keySpace(keyspace)
}

class CassandraDatabase(val keyspace: KeySpaceDef) extends Database(keyspace)
{

}

object CassandraDatabase extends CassandraDatabase(Defaults.cassandraConfig)

//trait AppDatabaseProvider {
//  val database: CassandraDatabase = CassandraDatabase
//}
