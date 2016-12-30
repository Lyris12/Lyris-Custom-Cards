--created & coded by Lyris
--ファントム妖怪女性－機光竜アイン
function c101010428.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE+RACE_THUNDER),4,2)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EFFECT_IMMUNE_EFFECT)
	e10:SetValue(c101010428.efilter)
	c:RegisterEffect(e10)
	
	
	
	
end
function c101010428.tcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsRace,1,nil,RACE_THUNDER)
end
function c101010428.dcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsRace,1,nil,RACE_MACHINE)
end
function c101010428.efilter(e,te)
	local c=te:GetHandler()
	return c:IsCode(503) or c:IsCode(539)
end

