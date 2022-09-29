import java.io.File
import java.lang.IllegalStateException
import kotlin.system.exitProcess

// This kotlin script copies comments from the original Pigeon templates and inserts them to the
// generated Dart files.
// Pigeon does not copy docs from the Dart templates, see https://github.com/flutter/flutter/issues/53191.
// Instead of dealing with the Pigeon sources this simple script was written.
//
// To use it you need kotlinc installed, available through sdk-man or brew, or packed with Android Studio
//
// Usage :
//      kotlinc -script copy-comments.kts -- \
//          -p mapbox-maps-flutter-internal/pigeons \
//          -g mapbox-maps-flutter-internal/lib/src/pigeons

val DOC_PREFIX = "///"

val pigeonsPath = if (args.contains("-p")) {
    args[1 + args.indexOf("-p")]
} else {
    println("No path to original Pigeon templates passed (-p arg), exit")
    exitProcess(1)
}

val generatedPath = if (args.contains("-g")) {
    args[1 + args.indexOf("-g")]
} else {
    println("No path to generated Pigeons passed (-g arg), exit")
    exitProcess(1)
}

val originalPigeons = File(pigeonsPath).listFiles().filter { it.name.endsWith(".dart") }
val generatedPigeons = File(generatedPath).listFiles().filter { it.name.endsWith(".dart.orig") }

originalPigeons.forEach { originalPigeonTemplate ->
    val generatedPigeonWithoutComments = generatedPigeons.firstOrNull {
        it.name.startsWith(originalPigeonTemplate.name)
    }
    if (generatedPigeonWithoutComments == null) {
        println("Can not find generated Pigeons matching Pigeon template ${originalPigeonTemplate.name}, exit")
        exitProcess(1)
    }

    println("Copy comments from ${originalPigeonTemplate.path} to ${generatedPigeonWithoutComments.path}")
    copyComments(originalPigeonTemplate, generatedPigeonWithoutComments)
}

// represents class or enum
data class Node(
    // node name - first line of class definition, e.g. `abstract Class smth {`
    val name: String,
    val nodeComment: List<String>,
    // children of node with comments, e.g. any line prepended with the single or multiline comment
    // prefix, may be method or field
    val childrenWithComments: Map<String, List<String>>
) {
    companion object {
        fun isNodeLabel(line: String) =
            line.startsWith("class ")
                    || line.startsWith("enum ")
                    || line.startsWith("abstract class ")
    }
}

fun copyComments(originalPigeonTemplate: File, generatedPigeonWithoutComments: File) {
    val outputFile = File(generatedPigeonWithoutComments.absolutePath.substringBeforeLast(".orig")).bufferedWriter()

    // map of node names to Nodes
    val nodes = mutableMapOf<String, Node>()

    var nodeName = ""
    var nodeComment = listOf<String>()
    var commentLines = listOf<String>()
    var childrenWithComments = mutableMapOf<String, List<String>>()

    // parse original Pigeon template to nodes map
    originalPigeonTemplate.readLines().forEach { pigeonLine ->
        if (pigeonLine.trim().startsWith(DOC_PREFIX)) {
            commentLines = commentLines + pigeonLine
        } else {
            if (Node.isNodeLabel(pigeonLine)) {
                if (nodeName.isNotBlank()) {
                    nodes[nodeName] = Node(nodeName, nodeComment, childrenWithComments)
                }
                nodeName = pigeonLine
                nodeComment = commentLines
                commentLines = listOf()
                childrenWithComments = mutableMapOf()
            } else {
                if (pigeonLine.isBlank()) {
                    commentLines = listOf()
                } else if (!commentLines.isEmpty()) {
                    childrenWithComments[pigeonLine] = commentLines
                    commentLines = listOf()
                }
            }
        }
    }
    if (nodeName.isNotBlank()) {
        nodes[nodeName] = Node(nodeName, commentLines, childrenWithComments)
    }

    var currentNode: Node? = null
    // insert comments to the file generatedPigeonWithoutComments by Pigeon if they are present in the original templates
    generatedPigeonWithoutComments.readLines().forEach { generatedLine ->
        if (Node.isNodeLabel(generatedLine)) {
            // if line is node - insert node nodeComment
            currentNode = nodes[generatedLine]
            currentNode?.nodeComment?.forEach(outputFile::appendLine)
        } else {
            // insert node child nodeComment
            currentNode?.childrenWithComments?.get(generatedLine)?.forEach(outputFile::appendLine)
        }
        outputFile.appendLine(generatedLine)
    }
    outputFile.flush()
}
