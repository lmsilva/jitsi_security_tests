#!/bin/bash
HOSTNAME="meet.jit.si"
MEETINGROOM="testmeeting15"
NICKNAME="Evil dude"
ROOMSECRET="segredo"
RID="2347156100"

HEADER="Accept: */*" \
	"Accept-Encoding: deflate, br" \
	"Accept-Language: en-US,en;q=0.9,pt;q=0.8,ru;q=0.7,es;q=0.6,pl;q=0.5" \
	"Connection: keep-alive" \
	"Content-Type: text/xml; charset=UTF-8" \
	"Host: $HOSTNAME" \
	"Origin: https://$HOSTNAME" \
	"Sec-Fetch-Dest: empty" \
	"Sec-Fetch-Mode: cors" \
	"Sec-Fetch-Site: same-origin" \
	"User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36"

RESPONSE=`curl -X POST -H "$HEADER" -d "<body content=\"text/xml; charset=utf-8\" hold=\"1\" rid=\"$RID\" to=\"$HOSTNAME\" ver=\"1.6\" wait=\"60\" xml:lang=\"en\" xmlns=\"http://jabber.org/protocol/httpbind\" xmlns:xmpp=\"urn:xmpp:xbosh\" xmpp:version=\"1.0\"/>" https://$HOSTNAME/http-bind?room=$MEETINGROOM`

echo "RESPONSE: $RESPONSE"
AUTHID=`echo $RESPONSE | grep -oPm1 "(authid=)[^<]+" | cut -f2 -d"'"`
SID=`echo $RESPONSE | grep -oPm1 "(sid=)[^<]+" | cut -f2 -d"'"`
RID=`expr $RID + 1`

echo "SID is $SID"

RESPONSE=`curl -X POST -H "$HEADER" -d "<body rid=\"$RID\" sid=\"$SID\" xmlns=\"http://jabber.org/protocol/httpbind\"><auth mechanism=\"ANONYMOUS\" xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\"/></body>" https://$HOSTNAME/http-bind?room=$MEETINGROOM`
echo "RESPONSE: $RESPONSE"
RID=`expr $RID + 1`

RESPONSE=`curl -X POST -H "$HEADER" -d "<body rid=\"$RID\" sid=\"$SID\" to=\"$HOSTNAME\" xml:lang=\"en\" xmlns=\"http://jabber.org/protocol/httpbind\"> xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\"/></body>" https://$HOSTNAME/http-bind?room=$MEETINGROOM`
echo "RESPONSE: $RESPONSE"
RID=`expr $RID + 1`


RESPONSE=`curl -X POST -H "$HEADER" -d "<body rid=\"$RID\" sid=\"$SID\" xmlns=\"http://jabber.org/protocol/httpbind\"><iq id=\"_bind_auth_2\" type=\"set\" xmlns=\"jabber:client\"><bind xmlns=\"urn:ietf:params:xml:ns:xmpp-bind\"/></iq></body>" https://$HOSTNAME/http-bind?room=$MEETINGROOM`
echo "RESPONSE: $RESPONSE"
RID=`expr $RID + 1`

RESPONSE=`curl -X POST -H "$HEADER" -d "<body rid=\"$RID\" sid=\"$SID\" xmlns=\"http://jabber.org/protocol/httpbind\"><iq id=\"_session_auth_2\" type=\"set\" xmlns=\"jabber:client\"><bind xmlns=\"urn:ietf:params:xml:ns:xmpp-bind\"/></iq></body>" https://$HOSTNAME/http-bind?room=$MEETINGROOM`
TO=`echo $RESPONSE | grep -oPm1 "(to=)[^<]+" | cut -f2 -d"'"`
echo "RESPONSE: $RESPONSE"
echo "$TO"
RID=`expr $RID + 1`

RESPONSE=`curl -X POST -H "$HEADER" -d "<body rid=\"$RID\" sid=\"$SID\" xmlns=\"http://jabber.org/protocol/httpbind\"><iq from=\"$TO\" id=\"1dde0b0c-7f48-42b9-af7e-a091a6107d0c:sendIQ\" to=\"$HOSTNAME\" type=\"get\" xmlns=\"jabber:client\"><query xmlns=\"http://jabber.org/protocol/disco#info\"/></iq></body>" https://$HOSTNAME/http-bind?room=$MEETINGROOM`
echo "RESPONSE: $RESPONSE"
RID=`expr $RID + 1`

#RESPONSE=`curl -X POST -H "$HEADER" -d "<body rid=\"$RID\" sid=\"$SID\" xmlns=\"http://jabber.org/protocol/httpbind\"/>" https://$HOSTNAME/http-bind?room=$MEETINGROOM`
#echo "RESPONSE: $RESPONSE"
#RID=`expr $RID + 1`

RESPONSE=`curl -X POST -H "$HEADER" -d "<body rid=\"$RID\" sid=\"$SID\" xmlns=\"http://jabber.org/protocol/httpbind\"><iq id=\"2a7e641d-f46a-4e54-b159-64a580f2202c:sendIQ\" to=\"focus.$HOSTNAME\" type=\"set\" xmlns=\"jabber:client\"><conference machine-uid=\"f768da7eab215c3316277e9407d33775\" room=\"$MEETINGROOM@conference.$HOSTNAME\" xmlns=\"http://jitsi.org/protocol/focus\"><property name=\"channelLastN\" value=\"-1\"/><property name=\"disableRtx\" value=\"false\"/><property name=\"enableLipSync\" value=\"true\"/><property name=\"openSctp\" value=\"true\"/></conference></iq></body>" https://$HOSTNAME/http-bind?room=$MEETINGROOM`
echo "RESPONSE: $RESPONSE"
RID=`expr $RID + 1`

RESPONSE=`curl -X POST -H "$HEADER" -d "<body rid=\"$RID\" sid=\"$SID\" xmlns=\"http://jabber.org/protocol/httpbind\"><presence to=\"$MEETINGROOM@conference.$HOSTNAME/5d2c750b\" xmlns=\"jabber:client\"><x xmlns=\"http://jabber.org/protocol/muc\"/><stats-id>Mable-myg</stats-id><c hash=\"sha-1\" node=\"http://jitsi.org/jitsimeet\" ver=\"bInwKC/7Lt0uq2Y1/f66QQKgRS4=\" xmlns=\"http://jabber.org/protocol/caps\"/><avatar-id>a47e27aec320d624ba15189b2dae0052</avatar-id><nick xmlns=\"http://jabber.org/protocol/nick\">$NICKNAME</nick><audiomuted xmlns=\"http://jitsi.org/jitmeet/audio\">false</audiomuted><videoType xmlns=\"http://jitsi.org/jitmeet/video\">camera</videoType><videomuted xmlns=\"http://jitsi.org/jitmeet/video\">false</videomuted></presence></body>" https://$HOSTNAME/http-bind?room=$MEETINGROOM`
echo "RESPONSE: $RESPONSE"
RID=`expr $RID + 1`

RESPONSE=`curl -X POST -H "$HEADER" -d "<body rid=\"$RID\" sid=\"$SID\" xmlns=\"http://jabber.org/protocol/httpbind\"><presence to=\"$MEETINGROOM@conference.$HOSTNAME/5d2c750b\" xmlns=\"jabber:client\"><stats-id>Mable-myg</stats-id><c hash=\"sha-1\" node=\"http://jitsi.org/jitsimeet\" ver=\"bInwKC/7Lt0uq2Y1/f66QQKgRS4=\" xmlns=\"http://jabber.org/protocol/caps\"/><avatar-id>a47e27aec320d624ba15189b2dae0052</avatar-id><nick xmlns=\"http://jabber.org/protocol/nick\">$NICKNAME</nick><audiomuted xmlns=\"http://jitsi.org/jitmeet/audio\">false</audiomuted><videoType xmlns=\"http://jitsi.org/jitmeet/video\">camera</videoType><videomuted xmlns=\"http://jitsi.org/jitmeet/video\">false</videomuted></presence><iq id=\"14e323c6-95d7-4cae-baff-46dba6bd8e75:sendIQ\" to=\"$MEETINGROOM@conference.$HOSTNAME\" type=\"get\" xmlns=\"jabber:client\"><query xmlns=\"http://jabber.org/protocol/disco#info\"/></iq></body>" https://$HOSTNAME/http-bind?room=$MEETINGROOM`
echo "RESPONSE: $RESPONSE"
RID=`expr $RID + 1`

RESPONSE=`curl -X POST -H "$HEADER" -d "<body rid=\"$RID\" sid=\"$SID\" xmlns=\"http://jabber.org/protocol/httpbind\"><iq id=\"4b24691f-1751-4787-b879-7fc1953a936c:sendIQ\" to=\"$MEETINGROOM@conference.$HOSTNAME\" type=\"set\" xmlns=\"jabber:client\"><query xmlns=\"http://jabber.org/protocol/muc#owner\"><x type=\"submit\" xmlns=\"jabber:x:data\"><field var=\"FORM_TYPE\"><value>http://jabber.org/protocol/muc#roomconfig</value></field><field var=\"muc#roomconfig_roomsecret\"><value>$ROOMSECRET</value></field><field var=\"muc#roomconfig_whois\"><value>anyone</value></field></x></query></iq></body>" https://$HOSTNAME/http-bind?room=$MEETINGROOM`
echo "RESPONSE: $RESPONSE"
RID=`expr $RID + 1`
