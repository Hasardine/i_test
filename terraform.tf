terraform {
  required_providers {
    ionoscloud = {
      source = "ionos-cloud/ionoscloud"
      version = ">= 6.4.10"
    }
  }
}

provider "ionoscloud" {
  token                = var.ionos_token
}

resource "ionoscloud_datacenter" "vdc_bjm" {
  name                  = "Datacenter vdc_bjm"
  location              = "de/fra"
  description           = "datacenter description"
  sec_auth_protection   = false
}

resource "ionoscloud_lan" "lan_bjm" {
  datacenter_id         = ionoscloud_datacenter.vdc_bjm.id
  public                = false
  name                  = "Lan lan_bjm"
  lifecycle {
    create_before_destroy = true
  }
}

resource "ionoscloud_ipblock" "ipblock_bjm" {
  location              = "de/fra"
  size                  = 3
  name                  = "IP Block ipblock_bjm"
}

resource "ionoscloud_k8s_cluster" "k8_bjm" {
  name                  = "k8_bjm"
  k8s_version           = "1.28.6"
  maintenance_window {
    day_of_the_week     = "Sunday"
    time                = "09:00:00Z"
  }
}

resource "ionoscloud_k8s_node_pool" "k8_bjm_nodes" {
  datacenter_id         = ionoscloud_datacenter.k8_bjm.id
  k8s_cluster_id        = ionoscloud_k8s_cluster.k8_bjm.id
  name                  = "k8sNodePoolk8_bjm"
  k8s_version           = ionoscloud_k8s_cluster.k8_bjm.k8s_version
  maintenance_window {
    day_of_the_week     = "Sunday"
    time                = "09:00:00Z"
  } 
  cpu_family            = "INTEL_XEON"
  availability_zone     = "AUTO"
  storage_type          = "SSD"
  node_count            = 2
  cores_count           = 2
  ram_size              = 2048
  storage_size          = 40
  public_ips            = [ ionoscloud_ipblock.ipblock_bjm.ips[0], ionoscloud_ipblock.ipblock_bjm.ips[1], ionoscloud_ipblock.ipblock_bjm.ips[2] ]
  lans {
    id                  = ionoscloud_lan.lan_bjm.id
    dhcp                = true
    routes {
       network          = "1.2.3.5/24"
       gateway_ip       = "10.1.5.17"
     }
   }  
}