Feature: NetTester API サーバの hosts API 実行

  Scenario: host 登録なしで hosts の取得
    When GET リクエストを "/hosts" に送信
    Then レスポンスのステータスコードが "200" である
    And JSON レスポンスが以下である
      """
      []
      """

  Scenario: vlan なしの host の登録
    When DPID が 0x123 の NetTester 物理スイッチ
    And PUT リクエストを "/hosts/host1" に送信
      """
      {
        "mac_address": "00:00:00:00:00:01",
        "ip_address": "192.168.0.100",
        "netmask": "255.255.255.0",
        "gateway": "192.168.0.1",
        "virtual_port_number": 2,
        "physical_port_number": 2
      }
      """
    Then 次のファイルができる:
      | log/NetTesterController.log  |
      | pids/NetTesterController.pid |
    And レスポンスのステータスコードが "200" である
    And JSON レスポンスが以下である
      """
      {
        "netns": {
          "name":"host1",
          "ip_address": "192.168.0.100",
          "mac_address": "00:00:00:00:00:01",
          "netmask": "255.255.255.0",
          "route": {
            "net": "0.0.0.0",
            "gateway": "192.168.0.1"
          },
          "vlan": null
         },
        "physical_port_number": 2,
        "virtual_port_number": 2,
        "vlan_id": null
      }
      """

  Scenario: vlan ありの host の登録
    When DPID が 0x123 の NetTester 物理スイッチ
    And PUT リクエストを "/hosts/host2" に送信
      """
      {
        "mac_address": "00:00:00:00:00:02",
        "ip_address": "192.168.0.101",
        "netmask": "255.255.255.0",
        "gateway": "192.168.0.1",
        "virtual_port_number": 3,
        "physical_port_number": 3,
        "vlan_id": 2000
      }
      """
    Then 次のファイルができる:
      | log/NetTesterController.log  |
      | pids/NetTesterController.pid |
    And レスポンスのステータスコードが "200" である
    And JSON レスポンスが以下である
      """
      {
        "netns": {
          "name":"host2",
          "ip_address": "192.168.0.101",
          "mac_address": "00:00:00:00:00:02",
          "netmask": "255.255.255.0",
          "route": {
            "net": "0.0.0.0",
            "gateway": "192.168.0.1"
          },
          "vlan": null
         },
        "physical_port_number": 3,
        "virtual_port_number": 3,
        "vlan_id": 2000
      }
      """

  Scenario: host 登録後の hosts の取得
    When DPID が 0x123 の NetTester 物理スイッチ
    And PUT リクエストを "/hosts/host1" に送信
      """
      {
        "mac_address": "00:00:00:00:00:01",
        "ip_address": "192.168.0.100",
        "netmask": "255.255.255.0",
        "gateway": "192.168.0.1",
        "virtual_port_number": 2,
        "physical_port_number": 2
      }
      """
    And PUT リクエストを "/hosts/host2" に送信
      """
      {
        "mac_address": "00:00:00:00:00:02",
        "ip_address": "192.168.0.101",
        "netmask": "255.255.255.0",
        "gateway": "192.168.0.1",
        "virtual_port_number": 3,
        "physical_port_number": 3,
        "vlan_id": 2000
      }
      """
    And GET リクエストを "/hosts" に送信
    Then レスポンスのステータスコードが "200" である
    And JSON レスポンスが以下である
      """
      [
        {
          "name":"host1",
          "ip_address": "192.168.0.100",
          "mac_address": "00:00:00:00:00:01",
          "netmask": "255.255.255.0",
          "route": {
            "net": null,
            "gateway": null
          },
          "vlan": null
        },
        {
          "name":"host2",
          "ip_address": "192.168.0.101",
          "mac_address": "00:00:00:00:00:02",
          "netmask": "255.255.255.0",
          "route": {
            "net": null,
            "gateway": null
          },
          "vlan": null
        }
      ]
      """

