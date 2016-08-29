--準星誕生
function c101010415.initial_effect(c)
	--Activate After "Dark Hole" resolves and destroys a "Stardust Dragon"(s), "Shooting Star Dragon"(s), and/or 3 or more "Photon" monsters: Special Summon 1 "Shooting Quasar Dragon" from your Extra Deck. (This is treated as a Synchro Summon. All LIGHT monsters and WIND Dragon-Type monsters that were destroyed by that "Dark Hole" become the Summoned Monster's Synchro Materials.)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(0xff)
	e1:SetOperation(c101010415.chop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(0xff)
	e2:SetOperation(c101010415.chop2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetHintTiming(TIMING_CHAIN_END,TIMING_CHAIN_END)
	--e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetLabelObject(e1)
	e3:SetCondition(c101010415.hspcon)
	--e3:SetTarget(c101010415.hsptg)
	e3:SetOperation(c101010415.hspop)
	c:RegisterEffect(e3)
end
function c101010415.filter(c,g)
	--[[local re=c:GetReasonEffect()
	return re:GetHandler():IsCode(53129443) and (]]
	return c:IsCode(44508094) or c:IsCode(24696097) or (c:IsSetCard(0x55) and g:GetCount()>=3)--)
end
function c101010415.chop(e,tp,eg,ep,ev,re,r,rp)
	if eg and eg:IsExists(c101010415.filter,1,nil,eg) then
		e:SetLabelObject(eg)
	end
end
function c101010415.chop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:GetHandler():IsCode(53129443) and e:GetLabelObject():GetLabelObject() and c:GetFlagEffect(101010415)==0 then
		Debug.ShowHint("h")
		c:RegisterFlagEffect(101010415,RESET_EVENT+0x1fe0000,0,0)
	end
end
function c101010415.hspcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(101010415)~=0 then
		c:ResetFlagEffect(101010415)
		return true
	else return false end
end
function c101010415.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_EXTRA,0,nil,35952884)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010415.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or (c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_DRAGON))
end
function c101010415.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_EXTRA,0,nil,35952884)
	if c then
		local mg=e:GetLabelObject():GetLabelObject()
		if mg then c:SetMaterial(mg:Filter(c101010415.mfilter,nil)) end
		Duel.SpecialSummon(c,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end
end
