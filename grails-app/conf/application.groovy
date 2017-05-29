
grails.cache.enabled = true
grails.cache.clearAtStartup = true
grails.cache.config = {
	defaults {
		maxElementsInMemory 10000
		eternal false
		timeToIdleSeconds 86400
		timeToLiveSeconds 86400
		overflowToDisk false
		maxElementsOnDisk 0
		diskPersistent false
		diskExpiryThreadIntervalSeconds 120
		memoryStoreEvictionPolicy 'LRU'
	}
	provider {
		name 'ehcache-spcon-' + (new Date().format('yyyyMMddHHmmss'))
	}
	cache {
		name 'spcon-cache'
	}
}

