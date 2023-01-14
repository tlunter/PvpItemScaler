local function addText(tooltip, itemLink)
  local itemInfo = { GetItemInfo(itemLink) };
  local detailedItemLevelInfo = { GetDetailedItemLevelInfo(itemLink) };

  -- DevTools_Dump({ itemLink, itemCount, itemInfo, detailedItemLevelInfo })

  tooltip:AddLine("Test")
  tooltip:Show()
end

local TooltipHandlers = {}

-- This is called when mousing over an item in your bags
TooltipHandlers["GetBagItem"] = function(tooltip, bag, slot)
  local itemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)

  if C_Item.DoesItemExist(itemLocation) then
    local itemLink = C_Item.GetItemLink(itemLocation);

    addText(tooltip, itemLink)
  end
end

-- This is called when mousing over an item in a merchant window (Merchant Pane)
TooltipHandlers["GetMerchantItem"] = function(tooltip, index)
  local itemLink = GetMerchantItemLink(index)

  addText(tooltip, itemLink)
end

-- This is called when mousing over an item in your bank, or a bag in your bag list
TooltipHandlers["GetInventoryItem"] = function(tooltip, unit, slot)
  local itemLink = GetInventoryItemLink(unit, slot)

  addText(tooltip, itemLink)
end

TooltipHandlers["GetHyperlink"] = function (tooltip)
  local itemLink = C_Item.GetItemLinkByGUID(tooltip.info.tooltipData.guid)
  addText(tooltip, itemLink)
end

local function get_keys(t)
  local keys={}
  for key, _ in pairs(t) do
    if string.find(key, "Tooltip") and string.find(key, "Item") and not string.find("Texture") then
      table.insert(keys, key)
    end
  end
  return keys
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
  if tooltip == GameTooltip or tooltip == ItemRefTooltip then
    if not tooltip.info or not tooltip.info.getterName or tooltip.info.excludeLines then
      return
    end

    local handler = TooltipHandlers[tooltip.info.getterName]

    if handler ~= nil then
      handler(tooltip, unpack(tooltip.info.getterArgs))
    end
  elseif tooltip == ShoppingTooltip1 or tooltip == ShoppingTooltip2 then
    TooltipHandlers["GetHyperlink"](tooltip)
  end
end)

local loadFrame = CreateFrame("FRAME");
loadFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
loadFrame:SetScript("OnEvent", function(self, event, ...)
  if event == "PLAYER_ENTERING_WORLD" then
    ChatFrame1:SetMaxLines(4096);
  end
end);
