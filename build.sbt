name := """play-scala-akka-cassandra-demo"""

version := "1.0-SNAPSHOT"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.11.8"

libraryDependencies ++= Seq(
  jdbc,
  cache,
  ws,
  "com.websudos"  %% "phantom-dsl" % "1.29.3",
  //"org.apache.tinkerpop" %% "gremlin-driver" % "^3.2.3",
  "com.michaelpollmeier" %% "gremlin-scala" % "3.2.2.0",
//  "com.datastax.cassandra"  % "cassandra-driver-core" % "2.0.2",
//  "com.datastax.cassandra" %% "dse-driver" % "1.1.0",
  "io.surfkit" %% "reactive-gremlin" % "0.0.1",
//  "org.tinymediamanager.plugins" % "scraper-imdb" % "1.7",
  "org.scalatestplus.play" %% "scalatestplus-play" % "1.5.1" % Test
)

resolvers += "scalaz-bintray" at "http://dl.bintray.com/scalaz/releases"
resolvers += "Sonatype OSS Snapshots" at "https://oss.sonatype.org/content/repositories/snapshots"
resolvers ++= Seq(
  "Java.net Maven2 Repository"       at "http://download.java.net/maven/2/",
  "Twitter Repository"               at "http://maven.twttr.com",
//  Resolver.typesafeRepo("releases"),
  Resolver.sonatypeRepo("releases"),
  Resolver.bintrayRepo("websudos", "oss-releases"),
  Resolver.sonatypeRepo("snapshots")
)
