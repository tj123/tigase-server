package tigase.plugins;

import tigase.db.NonAuthUserRepository;
import tigase.db.TigaseDBException;
import tigase.server.Packet;
import tigase.xmpp.*;

import java.util.*;

public class TestPlugin extends XMPPProcessor implements XMPPProcessorIfc {

    private static final String TEST_PLUGIN = "test-plugin";

    private static final String[] XMLNSS = {Packet.CLIENT_XMLNS};
    private static final Set<StanzaType> TYPES;
    private static final String MESSAGE = "message";
    private static final String[][] ELEMENT_PATHS = {{MESSAGE}};

    static {
        HashSet<StanzaType> tmpTYPES = new HashSet<StanzaType>();
        tmpTYPES.add(null);
        tmpTYPES.addAll(EnumSet.of(StanzaType.groupchat, StanzaType.chat));
        TYPES = Collections.unmodifiableSet(tmpTYPES);
    }

    @Override
    public void process(Packet packet, XMPPResourceConnection session, NonAuthUserRepository repo,
                        Queue<Packet> results, Map<String, Object> settings) throws XMPPException {

        StanzaType type = packet.getType();
        JID toJid = packet.getStanzaTo();
        JID fromJid = packet.getStanzaFrom();


        System.out.println(packet);
        System.out.println(session);
        System.out.println(repo);
        System.out.println(results);


    }

    @Override
    public String id() {
        return TEST_PLUGIN;
    }

    @Override
    public void init(Map<String, Object> settings) throws TigaseDBException {
        System.out.println("初始化了");
    }

    @Override
    public String[][] supElementNamePaths() {
        return ELEMENT_PATHS;

    }

    @Override
    public String[] supNamespaces() {
        return XMLNSS;
    }

    @Override
    public Set<StanzaType> supTypes() {
        return TYPES;
    }
}
