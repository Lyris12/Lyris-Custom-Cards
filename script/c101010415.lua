--闇の時間竜－ディアルガЯ
local id,ref=GIR()
function ref.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(ref.fscon)
	e1:SetOperation(ref.fsop)
	c:RegisterEffect(e1)
	--LIGHT Machine
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(0xf3)
	e0:SetTargetRange(0xf3,0)
	e0:SetTarget(ref.atcon)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetValue(RACE_MACHINE)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(0xf3)
	e2:SetTargetRange(0xf3,0)
	e2:SetTarget(ref.atcon)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e2)
	--link
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_REMOVED,LOCATION_REMOVED)
	e3:SetTarget(ref.f3filter1)
	e3:SetValue(ref.efilter)
	c:RegisterEffect(e3)
	--Absolute Rewind
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(ref.descost)
	e4:SetTarget(ref.destg)
	e4:SetOperation(ref.desop)
	c:RegisterEffect(e4)
end
function ref.f3filter1(e,c)
	return c:IsSetCard(0x5d) and c:IsType(TYPE_SPELL)
end
function ref.atcon(e)
	return e:GetHandler()
end
function ref.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function ref.ffilter(c)
	return c:IsRace(RACE_MACHINE) or c:IsRace(RACE_DRAGON) or (c:IsSetCard(0x5d) and c:IsType(TYPE_SPELL))
end
function ref.f1filter(c)
	return c:IsRace(RACE_DRAGON)
end
function ref.f2filter(c)
	return c:IsRace(RACE_MACHINE)
end
function ref.f3filter(c)
	return c:IsSetCard(0x5d) and c:IsType(TYPE_SPELL)
end
function ref.fscon(e,g,gc,chkf)
	if g==nil then return true end
	if not gc then
		local loc1=LOCATION_SZONE
		local loc2=LOCATION_SZONE
		if not g:Filter(Card.IsControler,nil,e:GetHandlerPlayer()):IsExists(Card.IsOnField,1,nil) then loc1=0 end
		if not g:Filter(Card.IsControler,nil,1-e:GetHandlerPlayer()):IsExists(Card.IsOnField,1,nil) then loc2=0 end
		local mc=g:GetFirst()
		while mc do
			local lct=mc:GetLocation()
			local p=mc:GetControler()
			if p==e:GetHandlerPlayer() then loc1=bit.bor(loc1,lct) else loc2=bit.bor(loc2,lct) end
			mc=g:GetNext()
		end
		local sg=Duel.GetMatchingGroup(ref.f3filter,e:GetHandlerPlayer(),loc1,loc2,nil)
	end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if sg then mg:Merge(sg) end
	if gc then
		local b1=0 local b2=0 local b3=0
		local tc=g:GetFirst()
		while tc do
			if ref.f1filter(tc) then b1=1
				elseif ref.f2filter(tc) then b2=1
				elseif ref.f3filter(tc) then b3=1
			end
			tc=g:GetNext()
		end
		if ref.f1filter(gc) then b1=1
			elseif ref.f2filter(gc) then b2=1
			elseif ref.f3filter(gc) then b3=1
			else return false
		end
		return b1+b2+b3>2
	end
	local b1=0 local b2=0 local b3=0
	local fs=false
	local tc=g:GetFirst()
	while tc do
		if ref.f1filter(tc) then b1=1 if aux.FConditionCheckF(tc,chkf) then fs=true end end
		if ref.f2filter(tc) then b2=1 if aux.FConditionCheckF(tc,chkf) then fs=true end end
		if ref.f3filter(tc) then b3=1 if aux.FConditionCheckF(tc,chkf) then fs=true end end
		tc=g:GetNext()
	end
	return b1+b2+b3>=3 and (fs or chkf==PLAYER_NONE)
end
function ref.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local loc1=LOCATION_SZONE
	local loc2=LOCATION_SZONE
	if not eg:Filter(Card.IsControler,nil,tp):IsExists(Card.IsOnField,1,nil) then loc1=0 end
	if not eg:Filter(Card.IsControler,nil,1-tp):IsExists(Card.IsOnField,1,nil) then loc2=0 end
	local mc=eg:GetFirst()
	while mc do
		local lct=mc:GetLocation()
		local tlc=bit.band(loc1,lct)
		if tlc==0 then
			local p=mc:GetControler()
			if p==e:GetHandlerPlayer() then loc1=bit.bor(loc1,lct) else loc2=bit.bor(loc2,lct) end
		end
		mc=eg:GetNext()
	end
	local mg=Duel.GetMatchingGroup(ref.f3filter,e:GetHandlerPlayer(),loc1,loc2,nil)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	g:Merge(mg)
	if gc then
		local sg=eg:Filter(ref.ffilter,gc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,1,1,nil)
		sg:Remove(Card.IsRace,nil,g1:GetFirst():GetRace())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g2=sg:Select(tp,1,1,nil)
		g1:Merge(g2)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=eg:Filter(ref.ffilter,nil)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	if bit.band(g1:GetFirst():GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER then sg:Remove(Card.IsRace,nil,g1:GetFirst():GetRace())
	else sg:Remove(ref.f3filter,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	if bit.band(g2:GetFirst():GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER then sg:Remove(Card.IsRace,nil,g2:GetFirst():GetRace())
	else sg:Remove(ref.f3filter,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g3=sg:Select(tp,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetFusionMaterial(g1)
end
function ref.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function ref.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function ref.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
	end
end
