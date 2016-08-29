--2 or more "Crystal Beast" cards
--Must first be Fusion Summoned, or Special Summoned (from your banished, Graveyard, or Extra Deck) by banishing 7 "Crystal Beast" cards with different names from your field and/or Graveyard. (You do not use "Polymerization") If this card was Fusion Summoned, this card gains 350 ATK for each Fusion Material Monster with a different name used to Fusion Summon this card, also, apply these effects to this card:
--(all effects listed below)
--If this card was Special Summoned, except by Fusion Summon, this card's ATK becomes 4000, also, it gains the following effect:
--宝玉神 レインボー・プリズム・ドラゴン
function c101010278.initial_effect(c)
c:EnableReviveLimit()
	--splimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(c101010278.splimit)
	c:RegisterEffect(e5)
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c101010278.fscondition)
	e1:SetOperation(c101010278.fsoperation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCondition(c101010278.spcon)
	e2:SetOperation(c101010278.spop)
	e2:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e2)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c101010278.effop)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c101010278.matcheck)
	e3:SetLabelObject(e4)
	c:RegisterEffect(e3)
end
function c101010278.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c101010278.fsfilter(c,mg)
	return c:IsSetCard(0x34)
end
function c101010278.fscondition(e,mg,gc)
	if mg==nil then return false end
	if gc then return false end
	return mg:IsExists(c101010278.fsfilter,2,nil,mg)
end
function c101010278.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g=eg:FilterSelect(tp,c101010278.fsfilter,2,63,nil,eg)
	Duel.SetFusionMaterial(g)
end
function c101010278.spfilter(c)
	return c:IsSetCard(0x34) and (not c:IsOnField() or c:IsFaceup()) and c:IsAbleToRemoveAsCost()
end
function c101010278.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c101010278.spfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>6
end
function c101010278.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c101010278.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local rg=Group.CreateGroup()
	for i=1,7 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			rg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c101010278.matcheck(e,c)
	local ct=e:GetHandler():GetMaterial():GetClassCount(Card.GetCode)
	e:GetLabelObject():SetLabel(ct)
end
function c101010278.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if ct~=0 then
		local ae=Effect.CreateEffect(c)
		ae:SetType(EFFECT_TYPE_SINGLE)
		ae:SetCode(EFFECT_UPDATE_ATTACK)
		ae:SetValue(ct*350)
		ae:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(ae)
		if ct>=1 then
			local e1=Effect.CreateEffect(c)
			--Rainbow Overdrive: During either player's turn: you can send all "Crystal Beast" cards you control to the Graveyard; this card gains 700 ATK for each card sent.
			e1:SetCategory(CATEGORY_ATKCHANGE)
			e1:SetDescription(aux.Stringid(101010278,0))
			e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
			e1:SetHintTiming(TIMING_DAMAGE_STEP)
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCondition(c101010278.atcon)
			e1:SetCost(c101010278.atcost)
			e1:SetOperation(c101010278.atop)
			c:RegisterEffect(e1)
		end
		if ct>=2 then
			local e2=Effect.CreateEffect(c)
			--Prism Refraction: Each turn, this card can attack a monster (including your own) a number of times equal to half of the number of Fusion Material Monsters used for its Fusion Summon.
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetReset(RESET_EVENT+0x1ff0000)
			e2:SetCode(EFFECT_EXTRA_ATTACK)
			e2:SetValue(math.floor(c:GetMaterialCount()/2)-1)
			c:RegisterEffect(e2)
			local e9=Effect.CreateEffect(c)
			e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e9:SetReset(RESET_EVENT+0x1ff0000)
			e9:SetCode(EVENT_ATTACK_ANNOUNCE)
			e9:SetOperation(c101010278.oaop)
			c:RegisterEffect(e9)
		end
		if ct>=4 then
			local e3=Effect.CreateEffect(c)
			--Prism Wall: If this card attacks your monster, your opponent takes all Battle Damage that you would have taken from that battle.
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
			e3:SetReset(RESET_EVENT+0x1ff0000)
			e3:SetCondition(c101010278.bdrcon)
			e3:SetOperation(c101010278.bdrop)
			c:RegisterEffect(e3)
		end
		if ct>=5 then
			local e4=Effect.CreateEffect(c)
			--Prism Protection: While this card is face-up on the field “Crystal Beast” cards you control cannot be targeted by your opponent's card effects.
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetRange(LOCATION_MZONE)
			e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e4:SetTargetRange(LOCATION_MZONE,0)
			e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x34))
			e4:SetValue(c101010278.tgvalue)
			c:RegisterEffect(e4)
		end
		if ct>=7 then
			local e5=Effect.CreateEffect(c)
			--Prism Power: Return all (min. 5) banished "Crystal Beast" monsters to the deck; shuffle all other cards on the field into the decks.
			e5:SetCategory(CATEGORY_TODECK)
			e5:SetDescription(aux.Stringid(101010278,2))
			e5:SetType(EFFECT_TYPE_IGNITION)
			e5:SetRange(LOCATION_MZONE)
			e5:SetCost(c101010278.tdcost)
			e5:SetTarget(c101010278.tdtg)
			e5:SetOperation(c101010278.tdop)
			c:RegisterEffect(e5)
		end
		else
		local as=Effect.CreateEffect(c)
		as:SetType(EFFECT_TYPE_SINGLE)
		as:SetCode(EFFECT_SET_ATTACK_FINAL)
		as:SetValue(4000)
		as:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(as)
		local e6=Effect.CreateEffect(c)
		--Rainbow Protection: If this card would be destroyed, you can banish 1 "Crystal Beast" monster in your Graveyard instead.
		e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EFFECT_DESTROY_REPLACE)
		e6:SetTarget(c101010278.desreptg)
		e6:SetOperation(c101010278.desrepop)
		c:RegisterEffect(e6)
	end
end
function c101010278.atcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	return phase~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c101010278.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x34) and c:IsAbleToGraveAsCost()
end
function c101010278.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010278.afilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c101010278.afilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c101010278.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*700)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c101010278.cfilter(c)
	return c:IsSetCard(0x34) and (c:IsType(TYPE_XYZ) and c:IsAbleToExtraAsCost()) or c:IsAbleToDeckAsCost()
end
function c101010278.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010278.cfilter,tp,LOCATION_REMOVED,0,5,nil) end
	local g=Duel.GetMatchingGroup(c101010278.cfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c101010278.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c101010278.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c101010278.bdrcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at~=nil and at:GetControler()==tp
end
function c101010278.dircon(e)
	return e:GetHandler():GetAttackAnnouncedCount()>0
end
function c101010278.atkcon(e)
	return e:GetHandler():IsDirectAttacked()
end
function c101010278.cfilter2(c)
	return c:IsSetCard(0x34) and c:IsAbleToRemoveAsCost()
end
function c101010278.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010278.cfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	return Duel.SelectYesNo(tp,aux.Stringid(101010278,1))
end
function c101010278.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c101010278.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
function c101010278.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c101010278.oaop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101010278,3)) then
		local tc=g:Select(tp,1,1,e:GetHandler())
		Duel.HintSelection(tc)
		Duel.ChangeAttackTarget(tc:GetFirst())
		Duel.RaiseEvent(e:GetHandler(),EVENT_ATTACK_ANNOUNCE,tp,0,1-tp,0)
	end
end
function c101010278.bdrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetBattleDamage(ep)>0 then
		Duel.ChangeBattleDamage(1-ep,ev,false)
		Duel.ChangeBattleDamage(ep,0)
	end
end
