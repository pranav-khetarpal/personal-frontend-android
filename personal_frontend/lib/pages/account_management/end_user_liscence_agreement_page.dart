import 'package:flutter/material.dart';

class EndUserLiscenceAgreementPage extends StatelessWidget {
  const EndUserLiscenceAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('End User Liscence Agreement')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''End-User License Agreement (EULA) of Market Gather
This End-User License Agreement ("EULA") is a legal agreement between you and Market Gather

This EULA agreement governs your acquisition and use of our Market Gather software ("Software") directly from Market Gather or indirectly through a Market Gather authorized reseller or distributor (a "Reseller").

Please read this EULA agreement carefully before completing the installation process and using the Market Gather software. It provides a license to use the Market Gather software and contains warranty information and liability disclaimers.

If you register for a free trial of the Market Gather software, this EULA agreement will also govern that trial. By clicking "accept" or installing and/or using the Market Gather software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.

If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.

This EULA agreement shall apply only to the Software supplied by Market Gather herewith regardless of whether other software is referred to or described herein. The terms also apply to any Market Gather updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply.

License Grant
Market Gather hereby grants you a personal, non-transferable, non-exclusive licence to use the Market Gather software on your devices in accordance with the terms of this EULA agreement.

You are permitted to load the Market Gather software (for example a PC, laptop, mobile or tablet) under your control. You are responsible for ensuring your device meets the minimum requirements of the Market Gather software.

You are not permitted to:

Edit, alter, modify, adapt, translate or otherwise change the whole or any part of the Software nor permit the whole or any part of the Software to be combined with or become incorporated in any other software, nor decompile, disassemble or reverse engineer the Software or attempt to do any such things
Reproduce, copy, distribute, resell or otherwise use the Software for any commercial purpose
Allow any third party to use the Software on behalf of or for the benefit of any third party
Use the Software in any way which breaches any applicable local, national or international law
use the Software for any purpose that Market Gather considers is a breach of this EULA agreement
Intellectual Property and Ownership
Market Gather shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Market Gather.

Market Gather reserves the right to grant licences to use the Software to third parties.

Termination
This EULA agreement is effective from the date you first use the Software and shall continue until terminated. You may terminate it at any time upon written notice to Market Gather.

It will also terminate immediately if you fail to comply with any term of this EULA agreement. Upon such termination, the licenses granted by this EULA agreement will immediately terminate and you agree to stop all access and use of the Software. The provisions that by their nature continue and survive will survive any termination of this EULA agreement. This EULA was created by App EULA Template Generator from App-Privacy-Policy.com for Market Gather

Governing Law
This EULA agreement, and any dispute arising out of or in connection with this EULA agreement, shall be governed by and construed in accordance with the laws of us.

Generated using App Privacy Policy Generator''',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
