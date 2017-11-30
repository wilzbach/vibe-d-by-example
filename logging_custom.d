#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8.2"
subConfiguration "vibe-d" "vibe-core"
+/
import vibe.d;

final class CustomLogger : Logger {

    import std.stdio : File, stderr;

    private {
        File m_curFile;
        LogLine msg;
    }

    this(File outFile = stderr)
    {
        this.m_curFile = outFile;
    }

    int maxChars = 30;

    override void beginLine(ref LogLine msg)
        @trusted // FILE isn't @safe (as of DMD 2.065)
        {
		this.msg = msg;
		string pref;
		final switch (msg.level) {
			case LogLevel.trace: pref = "trc"; break;
			case LogLevel.debugV: pref = "dbv"; break;
			case LogLevel.debug_: pref = "dbg"; break;
			case LogLevel.diagnostic: pref = "dia"; break;
			case LogLevel.info: pref = "INF"; break;
			case LogLevel.warn: pref = "WRN"; break;
			case LogLevel.error: pref = "ERR"; break;
			case LogLevel.critical: pref = "CRITICAL"; break;
			case LogLevel.fatal: pref = "FATAL"; break;
			case LogLevel.none: assert(false);
		}
            auto tm = msg.time;
            static if (is(typeof(tm.fracSecs))) auto msecs = tm.fracSecs.total!"msecs"; // 2.069 has deprecated "fracSec"
            else auto msecs = tm.fracSec.msecs;
            //m_curFile.writef("[%08X:%08X %d.%02d.%02d %02d:%02d:%02d.%03d %s] ",
                    //msg.threadID, msg.fiberID,
                    //tm.year, tm.month, tm.day, tm.hour, tm.minute, tm.second, msecs,
                    //pref);
            if (msg.level > LogLevel.debugV)
            {
                import std.algorithm : max;
            m_curFile.writef("[..%-" ~ maxChars.to!string ~ "s:%-4d %d.%02d.%02d %02d:%02d:%02d.%03d %s] ",
                    msg.file[max(msg.file.length.to!int - maxChars, 0) .. $], msg.line, tm.year, tm.month, tm.day, tm.hour, tm.minute, tm.second, msecs,
                    pref);
            }
        }

    override void put(scope const(char)[] text)
    {
        if (msg.level > LogLevel.debugV)
            m_curFile.write(text);
    }

    override void endLine()
    {
        if (msg.level > LogLevel.debugV)
        {
            m_curFile.writeln();
            m_curFile.flush();
        }
    }
}

void main() {
    import vibe.core.log;
    setLogLevel(LogLevel.info);
    setLogFormat(FileLogger.Format.threadTime, FileLogger.Format.threadTime);

    shared logger = cast(shared) new CustomLogger();
    deregisterLogger(getLoggers()[0]);
	registerLogger(logger);

    listenHTTP(":8080", (req, res) {
        res.writeBody("Hello, World: " ~ req.path);
    });
    runApplication();
}
