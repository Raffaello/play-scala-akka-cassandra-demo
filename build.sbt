name := """play-scala-akka-cassandra-demo"""

version := "1.0-SNAPSHOT"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.11.8"

libraryDependencies ++= Seq(
//  jdbc,
  cache,
  ws,
  "com.websudos"  %% "phantom-dsl" % "1.29.3",
  "org.scalatestplus.play" %% "scalatestplus-play" % "1.5.1" % Test
)

//resolvers += Resolver.bintrayRepo("websudos", "oss-releases")
resolvers ++= Seq(
  "Java.net Maven2 Repository"       at "http://download.java.net/maven/2/",
  "Twitter Repository"               at "http://maven.twttr.com",
//  Resolver.typesafeRepo("releases"),
  Resolver.sonatypeRepo("releases"),
  Resolver.bintrayRepo("websudos", "oss-releases")
)

resolvers += "scalaz-bintray" at "http://dl.bintray.com/scalaz/releases"
