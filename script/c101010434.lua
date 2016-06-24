--Starry-Eyes Spatial Dragon
local id,ref=GIR()
function ref.start(c)
	--attack banish
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_TOGRAVE)
	ae1:SetType(EFFECT_TYPE_IGNITION)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(ref.bancon)
	ae1:SetTarget(ref.bantg)
	ae1:SetOperation(ref.banop)
	c:RegisterEffect(ae1)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
ref.spatial=true
--Spatial Formula filter(s)
-- ref.material1=function(mc) return true end
-- ref.material2=function(mc) return true end -- Invert this block of code on Division Spatial Monsters (begin)
-- ref.addt_spatial=true ref.subt_spatial=true ref.mult_spatial=true --choose 1, depending on the Spatial Formula
ref.divs_spatial=true --Division Procedure /
ref.stat=function(mc) return mc:GetAttack() end
ref.indicator=function(mc) return mc:GetLevel() end -- Invert this block of code on Division Spatial Monsters (end)
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,450)
	Duel.CreateToken(1-tp,450)
end
function ref.bancon(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function ref.atkfilter(c,atk)
	local gr=c:IsAbleToGrave()
	local def=c:GetBaseDefence()
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and ((atk>=c:GetBaseAttack() and gr) or (atk==def or (atk>def and gr)))
end
function ref.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(1-tp) and ref.atkfilter(chkc,c:GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(ref.atkfilter,tp,0,LOCATION_REMOVED,1,nil,c:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,ref.atkfilter,tp,0,LOCATION_REMOVED,1,1,nil,c:GetAttack())
	local atk=g:GetFirst():GetBaseAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	if not g:GetFirst():IsAbleToGrave() then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end
end
function ref.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		if c:IsRelateToEffect(e) and tc:GetBaseAttack()==c:GetAttack() then
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		end
		if tc:GetBaseDefence()>=c:GetAttack() then return end
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
