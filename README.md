# Jitsi Security Tests

Just some random tests I'm performing to Jitsi...
For the time being, created a script that can simulate a connection to Jitsi's XMPP server to either join or create a new room and set a password on it.

To use it, simply edit the top parameters on simulate.sh:
* HOSTNAME="meet.jit.si"
* MEETINGROOM="testmeeting15"
* NICKNAME="Evil dude"
* ROOMSECRET="segredo"
* SETROOMSECRET=1 # 1 for true

...and run the script!

Also noticed a few other things that might be worth pursuing:
* It seems any user can join a conference room, kick all other users and set a password on the room...

* Jicofo's configuration file, by default, is installed at /etc/jitsi/jicofo/config
  * In it, a few different parameters are defined: **JICOFO_SECRET, JICOFO_AUTH_USER and JICOFO_AUTH_PASSWORD**
  * By default, this file is NOT world readable! However, any unprivileged user with local access to the system can view those access credentials by looking at the Java process startup arguments:
  * e.g. java -Xmx3072m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp -Dnet.java.sip.communicator.SC_HOME_DIR_LOCATION=/etc/jitsi ... --host=localhost --domain=<SERVERHOSTNAME> --port=5347 --secret=**<THESECRET>** --user_name=**<THEUSERNAME>** --user_domain=auth.<SERVERHOSTNAME> --user_password=**<THEPASSWORD>**

* There's also an out of bounds string exception when generating conference rooms larger than 1023 characters, though there's a try / catch exception around it, so it seems to be handled properly
e.g. https://<SERVERHOSTNAME>/gckkhznugergdoembnvqtvnhhtafqbffpipcseobdoveigyicecqspenmdhciqqegxtldxlbcufcsafmycxpisgjehzwgyidhnrdwtrzeegvhipwxyovmtvophzydmbsersqybzuresymdhhfvfizqyczyeeilvpegftsutqgmwzbsssbykzxlkpkadyfhnpxfdlsqcdlhdbqbfjahllxnciwbxpzgyqdsseqlttcgeiqrzxcbxxixbogtyukjofdgdqxqmycqwjsgfcwhdnejxpefghocmmcjrfcbijldpoffkmggrposplmdizzeaccdvnjwcczddwoycmujhfjswqpepbtbcnmvfsyaysfgfrqudvasitaortzoosprkohrshfeodpftbvtfnnsjlxcnmhujwpheukbuhjeymffpkigtyojeawqrzhbrxlwnbtntuavnpzexcbztnrytwxnwfizxdvibihyhlaxanvltcheynudydlgrapjjgagmfexitmybblmkzymrcrhcygfinhgsspvllsbsrjegsklbdpmswsqmltgmaqmtrumebpnfwiioibdiyijeoulxgvjmltjexkuuliyazjptfkanpechmapzmmgwrnlkvkqhfcrwbbtyvgswyzuptilqtdjvbvmxmidkldepwamabpoqrdsezphqhvamdqkwhmwndxeowfswxqcfgsrvebdhzwgblyppcgabgpsrdrkmthancdwroazguunfgymuzbpahbxcnlutitijykmzypfjvbylfosiiosjczxhfkzhkhaswjhzdtdfratvcmuzxunjfpvzhllziqihnhiyufbmzcakocgjhmbtmrvyxsynohfechcwrxqdhxywfwfwncnqtqjdzxfxplgaekvhdrdvadglfroxgekviyippxbtwkdhtptysmtvprdbwybsyrymjczsaexcfwunyczrugzkiwinfwgcfsuphleyolgioquqinxtoswatjykitpotnfbb
`
Jicofo 2020-04-06 02:16:11.479 SEVERE: [67] org.jitsi.jicofo.xmpp.FocusComponent.handleIQSetImpl().324 org.jxmpp.stringprep.XmppStringprepException: Given string is longer then 1023 bytes
org.jxmpp.stringprep.XmppStringprepException: Given string is longer then 1023 bytes
        at org.jxmpp.jid.parts.Part.assertNotLongerThan1023BytesOrEmpty(Part.java:78)
        at org.jxmpp.jid.parts.Localpart.from(Localpart.java:139)
        at org.jitsi.xmpp.extensions.jitsimeet.ConferenceIqProvider.getRoomJid(ConferenceIqProvider.java:201)
        at org.jitsi.xmpp.extensions.jitsimeet.ConferenceIqProvider.parse(ConferenceIqProvider.java:71)
        at org.jitsi.xmpp.extensions.jitsimeet.ConferenceIqProvider.parse(ConferenceIqProvider.java:36)
        at org.jivesoftware.smack.provider.Provider.parse(Provider.java:43)
        at org.jitsi.xmpp.util.IQUtils.convert(IQUtils.java:162)
        at org.jitsi.jicofo.xmpp.FocusComponent.handleIQSetImpl(FocusComponent.java:254)
        at org.jitsi.xmpp.component.ComponentBase.handleIQSet(ComponentBase.java:362)
        at org.xmpp.component.AbstractComponent.processIQRequest(AbstractComponent.java:515)
        at org.xmpp.component.AbstractComponent.processIQ(AbstractComponent.java:289)
        at org.xmpp.component.AbstractComponent.processQueuedPacket(AbstractComponent.java:239)
        at org.xmpp.component.AbstractComponent.access$100(AbstractComponent.java:81)
        at org.xmpp.component.AbstractComponent$PacketProcessor.run(AbstractComponent.java:1051)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
        at java.lang.Thread.run(Thread.java:748)
Jicofo 2020-04-06 02:16:11.481 WARNING: [67] org.jitsi.jicofo.xmpp.FocusComponent.processIQ() (serving component 'Jitsi Meet Focus') Unexpected exception while processing IQ stanza: <iq type="set" to="focus.<SERVERHOSTNAME>" from="8a4d7635-0790-4d12-a3d4-a6b44131ab5c@<SERVERHOSTNAME>/f0801552-a4e2-4d0e-9c2d-2bed150c8c84" id="2bb458fe-4b30-44e7-a0fd-4694b0d64ff8:sendIQ"><conference xmlns="http://jitsi.org/protocol/focus" machine-uid="f768da7eab215c3316277e9407d33775" room="gckkhznugergdoembnvqtvnhhtafqbffpipcseobdoveigyicecqspenmdhciqqegxtldxlbcufcsafmycxpisgjehzwgyidhnrdwtrzeegvhipwxyovmtvophzydmbsersqybzuresymdhhfvfizqyczyeeilvpegftsutqgmwzbsssbykzxlkpkadyfhnpxfdlsqcdlhdbqbfjahllxnciwbxpzgyqdsseqlttcgeiqrzxcbxxixbogtyukjofdgdqxqmycqwjsgfcwhdnejxpefghocmmcjrfcbijldpoffkmggrposplmdizzeaccdvnjwcczddwoycmujhfjswqpepbtbcnmvfsyaysfgfrqudvasitaortzoosprkohrshfeodpftbvtfnnsjlxcnmhujwpheukbuhjeymffpkigtyojeawqrzhbrxlwnbtntuavnpzexcbztnrytwxnwfizxdvibihyhlaxanvltcheynudydlgrapjjgagmfexitmybblmkzymrcrhcygfinhgsspvllsbsrjegsklbdpmswsqmltgmaqmtrumebpnfwiioibdiyijeoulxgvjmltjexkuuliyazjptfkanpechmapzmmgwrnlkvkqhfcrwbbtyvgswyzuptilqtdjvbvmxmidkldepwamabpoqrdsezphqhvamdqkwhmwndxeowfswxqcfgsrvebdhzwgblyppcgabgpsrdrkmthancdwroazguunfgymuzbpahbxcnlutitijykmzypfjvbylfosiiosjczxhfkzhkhaswjhzdtdfratvcmuzxunjfpvzhllziqihnhiyufbmzcakocgjhmbtmrvyxsynohfechcwrxqdhxywfwfwncnqtqjdzxfxplgaekvhdrdvadglfroxgekviyippxbtwkdhtptysmtvprdbwybsyrymjczsaexcfwunyczrugzkiwinfwgcfsuphleyolgioquqinxtoswatjykitpotnfbb@conference.<SERVERHOSTNAME>"><property value="-1" name="channelLastN"/><property value="false" name="disableRtx"/><property value="true" name="enableLipSync"/><property value="true" name="openSctp"/></conference></iq>
org.jxmpp.stringprep.XmppStringprepException: Given string is longer then 1023 bytes
        at org.jxmpp.jid.parts.Part.assertNotLongerThan1023BytesOrEmpty(Part.java:78)
        at org.jxmpp.jid.parts.Localpart.from(Localpart.java:139)
        at org.jitsi.xmpp.extensions.jitsimeet.ConferenceIqProvider.getRoomJid(ConferenceIqProvider.java:201)
        at org.jitsi.xmpp.extensions.jitsimeet.ConferenceIqProvider.parse(ConferenceIqProvider.java:71)
        at org.jitsi.xmpp.extensions.jitsimeet.ConferenceIqProvider.parse(ConferenceIqProvider.java:36)
        at org.jivesoftware.smack.provider.Provider.parse(Provider.java:43)
        at org.jitsi.xmpp.util.IQUtils.convert(IQUtils.java:162)
        at org.jitsi.jicofo.xmpp.FocusComponent.handleIQSetImpl(FocusComponent.java:254)
        at org.jitsi.xmpp.component.ComponentBase.handleIQSet(ComponentBase.java:362)
        at org.xmpp.component.AbstractComponent.processIQRequest(AbstractComponent.java:515)
        at org.xmpp.component.AbstractComponent.processIQ(AbstractComponent.java:289)
        at org.xmpp.component.AbstractComponent.processQueuedPacket(AbstractComponent.java:239)
        at org.xmpp.component.AbstractComponent.access$100(AbstractComponent.java:81)
        at org.xmpp.component.AbstractComponent$PacketProcessor.run(AbstractComponent.java:1051)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
        at java.lang.Thread.run(Thread.java:748)
Jicofo 2020-04-06 02:16:12.517 SEVERE: [71] org.jitsi.jicofo.xmpp.FocusComponent.handleIQSetImpl().324 org.jxmpp.stringprep.XmppStringprepException: Given string is longer then 1023 bytes
org.jxmpp.stringprep.XmppStringprepException: Given string is longer then 1023 bytes
        at org.jxmpp.jid.parts.Part.assertNotLongerThan1023BytesOrEmpty(Part.java:78)
        at org.jxmpp.jid.parts.Localpart.from(Localpart.java:139)
        at org.jitsi.xmpp.extensions.jitsimeet.ConferenceIqProvider.getRoomJid(ConferenceIqProvider.java:201)
        at org.jitsi.xmpp.extensions.jitsimeet.ConferenceIqProvider.parse(ConferenceIqProvider.java:71)
        at org.jitsi.xmpp.extensions.jitsimeet.ConferenceIqProvider.parse(ConferenceIqProvider.java:36)
        at org.jivesoftware.smack.provider.Provider.parse(Provider.java:43)
        at org.jitsi.xmpp.util.IQUtils.convert(IQUtils.java:162)
        at org.jitsi.jicofo.xmpp.FocusComponent.handleIQSetImpl(FocusComponent.java:254)
        at org.jitsi.xmpp.component.ComponentBase.handleIQSet(ComponentBase.java:362)
        at org.xmpp.component.AbstractComponent.processIQRequest(AbstractComponent.java:515)
        at org.xmpp.component.AbstractComponent.processIQ(AbstractComponent.java:289)
        at org.xmpp.component.AbstractComponent.processQueuedPacket(AbstractComponent.java:239)
        at org.xmpp.component.AbstractComponent.access$100(AbstractComponent.java:81)
        at org.xmpp.component.AbstractComponent$PacketProcessor.run(AbstractComponent.java:1051)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
        at java.lang.Thread.run(Thread.java:748)
Jicofo 2020-04-06 02:16:12.519 WARNING: [71] org.jitsi.jicofo.xmpp.FocusComponent.processIQ() (serving component 'Jitsi Meet Focus') Unexpected exception while processing IQ stanza: <iq type="set" to="focus.<SERVERHOSTNAME>" from="8a4d7635-0790-4d12-a3d4-a6b44131ab5c@<SERVERHOSTNAME>/f0801552-a4e2-4d0e-9c2d-2bed150c8c84" id="dcbc357c-6cd0-4311-979f-195fda1b813e:sendIQ"><conference xmlns="http://jitsi.org/protocol/focus" machine-uid="f768da7eab215c3316277e9407d33775" room="gckkhznugergdoembnvqtvnhhtafqbffpipcseobdoveigyicecqspenmdhciqqegxtldxlbcufcsafmycxpisgjehzwgyidhnrdwtrzeegvhipwxyovmtvophzydmbsersqybzuresymdhhfvfizqyczyeeilvpegftsutqgmwzbsssbykzxlkpkadyfhnpxfdlsqcdlhdbqbfjahllxnciwbxpzgyqdsseqlttcgeiqrzxcbxxixbogtyukjofdgdqxqmycqwjsgfcwhdnejxpefghocmmcjrfcbijldpoffkmggrposplmdizzeaccdvnjwcczddwoycmujhfjswqpepbtbcnmvfsyaysfgfrqudvasitaortzoosprkohrshfeodpftbvtfnnsjlxcnmhujwpheukbuhjeymffpkigtyojeawqrzhbrxlwnbtntuavnpzexcbztnrytwxnwfizxdvibihyhlaxanvltcheynudydlgrapjjgagmfexitmybblmkzymrcrhcygfinhgsspvllsbsrjegsklbdpmswsqmltgmaqmtrumebpnfwiioibdiyijeoulxgvjmltjexkuuliyazjptfkanpechmapzmmgwrnlkvkqhfcrwbbtyvgswyzuptilqtdjvbvmxmidkldepwamabpoqrdsezphqhvamdqkwhmwndxeowfswxqcfgsrvebdhzwgblyppcgabgpsrdrkmthancdwroazguunfgymuzbpahbxcnlutitijykmzypfjvbylfosiiosjczxhfkzhkhaswjhzdtdfratvcmuzxunjfpvzhllziqihnhiyufbmzcakocgjhmbtmrvyxsynohfechcwrxqdhxywfwfwncnqtqjdzxfxplgaekvhdrdvadglfroxgekviyippxbtwkdhtptysmtvprdbwybsyrymjczsaexcfwunyczrugzkiwinfwgcfsuphleyolgioquqinxtoswatjykitpotnfbb@conference.<SERVERHOSTNAME>"><property value="-1" name="channelLastN"/><property value="false" name="disableRtx"/><property value="true" name="enableLipSync"/><property value="true" name="openSctp"/></conference></iq>
org.jxmpp.stringprep.XmppStringprepException: Given string is longer then 1023 bytes
        at org.jxmpp.jid.parts.Part.assertNotLongerThan1023BytesOrEmpty(Part.java:78)
        at org.jxmpp.jid.parts.Localpart.from(Localpart.java:139)
        at org.jitsi.xmpp.extensions.jitsimeet.ConferenceIqProvider.getRoomJid(ConferenceIqProvider.java:201)
        at org.jitsi.xmpp.extensions.jitsimeet.ConferenceIqProvider.parse(ConferenceIqProvider.java:71)
        at org.jitsi.xmpp.extensions.jitsimeet.ConferenceIqProvider.parse(ConferenceIqProvider.java:36)
        at org.jivesoftware.smack.provider.Provider.parse(Provider.java:43)
        at org.jitsi.xmpp.util.IQUtils.convert(IQUtils.java:162)
        at org.jitsi.jicofo.xmpp.FocusComponent.handleIQSetImpl(FocusComponent.java:254)
        at org.jitsi.xmpp.component.ComponentBase.handleIQSet(ComponentBase.java:362)
        at org.xmpp.component.AbstractComponent.processIQRequest(AbstractComponent.java:515)
        at org.xmpp.component.AbstractComponent.processIQ(AbstractComponent.java:289)
        at org.xmpp.component.AbstractComponent.processQueuedPacket(AbstractComponent.java:239)
        at org.xmpp.component.AbstractComponent.access$100(AbstractComponent.java:81)
        at org.xmpp.component.AbstractComponent$PacketProcessor.run(AbstractComponent.java:1051)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
        at java.lang.Thread.run(Thread.java:748)
`
