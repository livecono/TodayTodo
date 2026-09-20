package com.eunchan.todaytodo;

import com.getcapacitor.BridgeActivity;
import android.view.View;

public class MainActivity extends BridgeActivity {
	@Override
	public void onCreate(android.os.Bundle savedInstanceState) {
		registerPlugin(UpdatePlugin.class);
		super.onCreate(savedInstanceState);
		getBridge().getWebView().setOverScrollMode(View.OVER_SCROLL_NEVER);
	}
}
