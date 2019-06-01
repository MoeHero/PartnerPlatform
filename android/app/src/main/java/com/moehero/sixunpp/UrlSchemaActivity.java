package com.moehero.sixunpp;

import android.net.Uri;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class UrlSchemaActivity extends FlutterActivity {
    private static final String CHANNEL = "moehero.sixunpp.com/url_schema";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        BasicMessageChannel<Object> messageChannel = new BasicMessageChannel<>(getFlutterView(), CHANNEL, StandardMessageCodec.INSTANCE);
        messageChannel.setMessageHandler((Object o, BasicMessageChannel.Reply<Object> reply) -> {
            Uri uri = getIntent().getData();
            if(!uri.getPath().equals("/goQuestion")) return;
            messageChannel.send("goQuestion?id=" + uri.getQueryParameter("id"));
        });
    }
}
