package models.gremlin

import com.typesafe.config.ConfigFactory
import io.surfkit.gremlin.GremlinClient

object Defaults
{
  private val _gremlinConfig = ConfigFactory.load.getConfig("gremlin")
  val gremlin_host = _gremlinConfig.getString("host")
  val gremlin_max_in_flight = _gremlinConfig.getInt("max_in_flight")
}

object GremlinServer
{
  val client = new GremlinClient(host=Defaults.gremlin_host, maxInFlight=Defaults.gremlin_max_in_flight)
}
