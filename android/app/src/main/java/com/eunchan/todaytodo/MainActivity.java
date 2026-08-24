package com.eunchan.todaytodo;

import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
	@Override
	public void onCreate(android.os.Bundle savedInstanceState) {
		registerPlugin(UpdatePlugin.class);
		super.onCreate(savedInstanceState);
	}
}
